$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Fail($Message) {
  Write-Error $Message
  exit 1
}

$routing = Get-Content -Raw -Path (Join-Path $RepoRoot 'ROUTING.yaml')
$registry = Get-Content -Raw -Path (Join-Path $RepoRoot 'workflow-registry.yaml')
$manifest = Get-Content -Raw -Path (Join-Path $RepoRoot 'memory/MANIFEST.yaml')

$workflowIds = [regex]::Matches($registry, '(?m)^\s*-\s+workflow_id:\s*(\S+)') | ForEach-Object { $_.Groups[1].Value.Trim() }
$memoryIds = [regex]::Matches($manifest, '(?m)^\s*-\s+memory_id:\s*(\S+)') | ForEach-Object { $_.Groups[1].Value.Trim() }

$routes = [regex]::Matches($routing, '(?ms)^\s*-\s+task_type:\s*([^\r\n]+)(.*?)(?=^\s*-\s+task_type:|\z)')
if ($routes.Count -eq 0) { Fail 'routing_no_routes' }

$routeWorkflowSet = @{}
foreach ($route in $routes) {
  $taskType = $route.Groups[1].Value.Trim()
  $body = $route.Groups[2].Value
  foreach ($field in @('workflow','required_memory','required_practices','trace_requirement')) {
    if ($body -notmatch "(?m)^\s+${field}:") {
      Fail "route_missing_field: $taskType field=$field"
    }
  }
  $workflow = ([regex]::Match($body, '(?m)^\s+workflow:\s*(\S+)')).Groups[1].Value.Trim()
  if ($workflowIds -notcontains $workflow) {
    Fail "route_unknown_workflow: $taskType workflow=$workflow"
  }
  $routeWorkflowSet[$workflow] = $true
  $memLine = ([regex]::Match($body, '(?m)^\s+required_memory:\s*\[(.*?)\]')).Groups[1].Value
  foreach ($mem in ($memLine -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($memoryIds -notcontains $mem) {
      Fail "route_unknown_memory: $taskType memory=$mem"
    }
  }
  $prLine = ([regex]::Match($body, '(?m)^\s+required_practices:\s*\[(.*?)\]')).Groups[1].Value
  foreach ($practice in ($prLine -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if (-not (Test-Path -Path (Join-Path $RepoRoot $practice))) {
      Fail "route_missing_practice: $taskType practice=$practice"
    }
  }
}

foreach ($workflowId in $workflowIds) {
  if (-not $routeWorkflowSet.ContainsKey($workflowId)) {
    Fail "workflow_unrouted: $workflowId"
  }
}

Write-Host 'check-routing: ok'
