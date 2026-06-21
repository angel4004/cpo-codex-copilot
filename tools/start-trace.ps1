param(
  [Parameter(Mandatory=$true)][string]$WorkflowId,
  [string]$TraceEnforcementLevel = 'runner_only'
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$registry = Get-Content -Raw -Path (Join-Path $RepoRoot 'workflow-registry.yaml')
if ($registry -notmatch "(?m)workflow_id:\s*$([regex]::Escape($WorkflowId))\b") {
  Write-Error "unknown_workflow: $WorkflowId"
  exit 1
}

function Get-InlineList {
  param(
    [Parameter(Mandatory=$true)][string]$Body,
    [Parameter(Mandatory=$true)][string]$Field
  )
  $match = [regex]::Match($Body, "(?m)^\s+${Field}:\s*\[(.*?)\]\s*$")
  if (-not $match.Success) { return @() }
  return @($match.Groups[1].Value -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

function Get-Scalar {
  param(
    [Parameter(Mandatory=$true)][string]$Body,
    [Parameter(Mandatory=$true)][string]$Field
  )
  $match = [regex]::Match($Body, "(?m)^\s+${Field}:\s*(.+?)\s*$")
  if (-not $match.Success) { return "" }
  return $match.Groups[1].Value.Trim()
}

$routing = Get-Content -Raw -Path (Join-Path $RepoRoot 'ROUTING.yaml')
$routeTaskType = ""
$routeBody = ""
foreach ($routeMatch in [regex]::Matches($routing, '(?ms)^\s*-\s+task_type:\s*([^\r\n]+)(.*?)(?=^\s*-\s+task_type:|\z)')) {
  $candidateBody = $routeMatch.Groups[2].Value
  if ((Get-Scalar $candidateBody 'workflow') -eq $WorkflowId) {
    $routeTaskType = $routeMatch.Groups[1].Value.Trim()
    $routeBody = $candidateBody
    break
  }
}

$workflowMatch = [regex]::Match($registry, "(?ms)^\s*-\s+workflow_id:\s*$([regex]::Escape($WorkflowId))\s*(.*?)(?=^\s*-\s+workflow_id:|\z)")
$workflowBody = if ($workflowMatch.Success) { $workflowMatch.Groups[1].Value } else { "" }

$traceId = [guid]::NewGuid().ToString()
$sessionId = [guid]::NewGuid().ToString()
$gitSha = 'uncommitted'
$gitHeadPath = Join-Path $RepoRoot '.git/HEAD'
if (Test-Path -Path $gitHeadPath) {
  $headText = Get-Content -Raw -Path $gitHeadPath
  $canResolveHead = $false
  if ($headText -match '^ref:\s*(.+)$') {
    $refPath = Join-Path (Join-Path $RepoRoot '.git') $matches[1].Trim()
    $canResolveHead = Test-Path -Path $refPath
  } elseif ($headText.Trim().Length -ge 7) {
    $canResolveHead = $true
  }
  if ($canResolveHead) {
    $head = & git -C $RepoRoot rev-parse --short HEAD
    if ($LASTEXITCODE -eq 0 -and $head) {
      $gitSha = ($head | Select-Object -First 1).Trim()
    }
  }
}

$state = [ordered]@{
  trace_id = $traceId
  session_id = $sessionId
  workflow_id = $WorkflowId
  route_task_type = $routeTaskType
  required_memory = @(Get-InlineList $routeBody 'required_memory')
  required_practices = @(Get-InlineList $routeBody 'required_practices')
  required_checks = @((Get-InlineList $routeBody 'required_checks') + (Get-InlineList $workflowBody 'required_checks') | Sort-Object -Unique)
  trace_requirement = Get-Scalar $routeBody 'trace_requirement'
  requires_decision_record = Get-Scalar $workflowBody 'requires_decision_record'
  routing_refs = @('ROUTING.yaml','workflow-registry.yaml','memory/MANIFEST.yaml')
  trace_enforcement_level = $TraceEnforcementLevel
  git_sha = $gitSha
  started_at = (Get-Date).ToUniversalTime().ToString('o')
  status = 'open'
}

$statePath = Join-Path $RepoRoot 'traces/state/current-trace.json'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $statePath) | Out-Null
$state | ConvertTo-Json -Depth 5 | Set-Content -Path $statePath -Encoding utf8
Write-Host "start-trace: $traceId workflow=$WorkflowId level=$TraceEnforcementLevel"
