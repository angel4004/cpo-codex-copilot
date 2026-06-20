param(
  [Parameter(Mandatory=$true)][string]$WorkflowId,
  [string]$TraceEnforcementLevel = 'runner_only'
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

& (Join-Path $PSScriptRoot 'start-trace.ps1') -WorkflowId $WorkflowId -TraceEnforcementLevel $TraceEnforcementLevel
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$routingRefs = Select-String -Path (Join-Path $RepoRoot 'ROUTING.yaml') -Pattern "workflow:\s*$WorkflowId" -Context 2,8
Write-Host "run-workflow: workflow=$WorkflowId"
Write-Host 'Codex-visible context refs:'
Write-Host '- AGENTS.md'
Write-Host '- CONSTITUTION.md'
Write-Host '- docs/runtime-contract.md'
Write-Host '- workflow-registry.yaml'
Write-Host '- ROUTING.yaml'
Write-Host '- memory/MANIFEST.yaml'
if ($routingRefs) { Write-Host '- routing entry found' }
