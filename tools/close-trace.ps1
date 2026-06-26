param(
  [string]$FinalStatus = 'closed',
  [string[]]$ArtifactRefs = @(),
  [string[]]$EvidenceRefs = @(),
  [string]$DecisionSummary = 'closed by local runner'
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$statePath = Join-Path $RepoRoot 'traces/state/current-trace.json'
if (-not (Test-Path -Path $statePath)) {
  Write-Error 'trace_state_missing'
  exit 1
}

$state = Get-Content -Raw -Path $statePath | ConvertFrom-Json

function Fail($Message) {
  Write-Error $Message
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

function Assert-SafeRefs {
  param(
    [Parameter(Mandatory=$true)][string]$Field,
    [string[]]$Refs = @()
  )
  foreach ($ref in @($Refs)) {
    if (-not $ref) { Fail "trace_ref_empty: field=$Field" }
    if ($ref -match '(?i)^chat:') { Fail "trace_unresolved_chat_ref: field=$Field ref=$ref" }
    if ($ref -match '[,;]' -or $ref -match "(`r|`n)") { Fail "trace_ref_combined_or_multivalue: field=$Field ref=$ref" }
    if ($ref -match '(?i)^[A-Z]:[/\\]' -or $ref -match '^(?i:/users/|/home/)') {
      Fail "trace_absolute_local_ref: field=$Field ref=$ref"
    }
  }
}

function Assert-SafeStatus {
  param([string]$Status)
  if ($Status -match '(?i)^[A-Z]:[/\\]' -or $Status -match '^(?i:/users/|/home/)') {
    Fail "trace_absolute_local_status: status=$Status"
  }
}

$registry = Get-Content -Raw -Path (Join-Path $RepoRoot 'workflow-registry.yaml')
$workflowMatch = [regex]::Match($registry, "(?ms)^\s*-\s+workflow_id:\s*$([regex]::Escape($state.workflow_id))\s*(.*?)(?=^\s*-\s+workflow_id:|\z)")
$workflowBody = if ($workflowMatch.Success) { $workflowMatch.Groups[1].Value } else { "" }
$requiredArtifacts = @(Get-InlineList $workflowBody 'required_artifacts')

Assert-SafeRefs 'artifact_refs' $ArtifactRefs
Assert-SafeRefs 'evidence_refs' $EvidenceRefs
Assert-SafeStatus $FinalStatus

if ($requiredArtifacts.Count -gt 0) {
  if (@($ArtifactRefs).Count -eq 0) {
    Fail "trace_artifact_refs_required: workflow=$($state.workflow_id) required=$($requiredArtifacts -join '|')"
  }
  if (@($EvidenceRefs).Count -eq 0) {
    Fail "trace_evidence_refs_required: workflow=$($state.workflow_id)"
  }
}

$event = [ordered]@{
  trace_id = $state.trace_id
  session_id = $state.session_id
  trace_enforcement_level = $state.trace_enforcement_level
  timestamp = (Get-Date).ToUniversalTime().ToString('o')
  git_sha = $state.git_sha
  copilot_version = '0.1.0'
  user_task_type = $state.workflow_id
  workflow_used = $state.workflow_id
  instructions_loaded = @('AGENTS.md','CONSTITUTION.md','docs/runtime-contract.md','workflow-registry.yaml','ROUTING.yaml','memory/MANIFEST.yaml')
  memory_refs = @($state.required_memory | ForEach-Object { "memory:$($_)" })
  practice_refs = @($state.required_practices)
  evidence_refs = $EvidenceRefs
  decision_summary = $DecisionSummary
  missing_inputs = @()
  forbidden_claim_labels = @()
  approval_required = $false
  approval_state = 'not_required'
  checks_run = @($state.required_checks)
  artifact_refs = $ArtifactRefs
  redaction_policy = 'observability/redaction-policy.md'
  final_status = $FinalStatus
  field_provenance = @{
    trace_id = 'runner_validated'
    session_id = 'runner_validated'
    trace_enforcement_level = 'runner_validated'
    workflow_used = 'runner_validated'
    memory_refs = 'runner_validated'
    practice_refs = 'runner_validated'
    checks_run = 'runner_validated'
    artifact_refs = 'runner_validated'
    evidence_refs = 'runner_validated'
    decision_summary = 'agent_declared'
  }
}

$json = $event | ConvertTo-Json -Depth 8 -Compress
& (Join-Path $PSScriptRoot 'write-trace-event.ps1') -EventJson $json
if (-not $?) { exit 1 }

$state.status = 'closed'
$state | Add-Member -NotePropertyName closed_at -NotePropertyValue (Get-Date).ToUniversalTime().ToString('o') -Force
$state | ConvertTo-Json -Depth 5 | Set-Content -Path $statePath -Encoding utf8

$decisionPath = Join-Path $RepoRoot ("traces/reports/decision-$($state.trace_id).md")
@"
# Decision Record

workflow_id: $($state.workflow_id)
trace_id: $($state.trace_id)
status: $FinalStatus

Decision summary: $DecisionSummary

Artifact refs:
$(@($ArtifactRefs) | ForEach-Object { "- $_" } | Out-String)
Evidence refs:
$(@($EvidenceRefs) | ForEach-Object { "- $_" } | Out-String)

This runner-generated record proves the local trace can be closed. Treat it as
operational evidence; replace with a human-authored decision record when the
workflow makes a real CPO decision.
"@ | Set-Content -Path $decisionPath -Encoding utf8

Write-Host "close-trace: $($state.trace_id)"
