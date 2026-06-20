param(
  [string]$FinalStatus = 'closed',
  [string[]]$ArtifactRefs = @()
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$statePath = Join-Path $RepoRoot 'traces/state/current-trace.json'
if (-not (Test-Path -Path $statePath)) {
  Write-Error 'trace_state_missing'
  exit 1
}

$state = Get-Content -Raw -Path $statePath | ConvertFrom-Json
$event = [ordered]@{
  trace_id = $state.trace_id
  session_id = $state.session_id
  trace_enforcement_level = $state.trace_enforcement_level
  timestamp = (Get-Date).ToUniversalTime().ToString('o')
  git_sha = $state.git_sha
  copilot_version = '0.1.0'
  user_task_type = $state.workflow_id
  workflow_used = $state.workflow_id
  instructions_loaded = @('AGENTS.md','CONSTITUTION.md','docs/runtime-contract.md')
  memory_refs = @()
  practice_refs = @()
  evidence_refs = @()
  decision_summary = 'closed by local runner'
  missing_inputs = @()
  forbidden_claim_labels = @()
  approval_required = $false
  approval_state = 'not_required'
  checks_run = @()
  artifact_refs = $ArtifactRefs
  redaction_policy = 'observability/redaction-policy.md'
  final_status = $FinalStatus
  field_provenance = @{
    trace_id = 'runner_validated'
    session_id = 'runner_validated'
    trace_enforcement_level = 'runner_validated'
    workflow_used = 'runner_validated'
    decision_summary = 'agent_declared'
  }
}

$json = $event | ConvertTo-Json -Depth 8 -Compress
& (Join-Path $PSScriptRoot 'write-trace-event.ps1') -EventJson $json
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$state.status = 'closed'
$state.closed_at = (Get-Date).ToUniversalTime().ToString('o')
$state | ConvertTo-Json -Depth 5 | Set-Content -Path $statePath -Encoding utf8

$decisionPath = Join-Path $RepoRoot ("traces/reports/decision-$($state.trace_id).md")
@"
# Decision Record

workflow_id: $($state.workflow_id)
trace_id: $($state.trace_id)
status: $FinalStatus

This runner-generated record proves the local trace can be closed. Human CPO
decision content must be filled during real workflows.
"@ | Set-Content -Path $decisionPath -Encoding utf8

Write-Host "close-trace: $($state.trace_id)"
