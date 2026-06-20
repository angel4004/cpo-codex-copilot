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
  trace_enforcement_level = $TraceEnforcementLevel
  git_sha = $gitSha
  started_at = (Get-Date).ToUniversalTime().ToString('o')
  status = 'open'
}

$statePath = Join-Path $RepoRoot 'traces/state/current-trace.json'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $statePath) | Out-Null
$state | ConvertTo-Json -Depth 5 | Set-Content -Path $statePath -Encoding utf8
Write-Host "start-trace: $traceId workflow=$WorkflowId level=$TraceEnforcementLevel"
