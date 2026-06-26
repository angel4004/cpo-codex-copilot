$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Fail($Message) {
  Write-Error $Message
  exit 1
}

foreach ($rel in @('observability/trace-schema.md','observability/trace-provenance-schema.md','observability/redaction-policy.md','.codex/hooks.json')) {
  if (-not (Test-Path -Path (Join-Path $RepoRoot $rel))) { Fail "trace_contract_missing: $rel" }
}

$schema = Get-Content -Raw -Path (Join-Path $RepoRoot 'observability/trace-schema.md')
foreach ($field in @('trace_id','session_id','trace_enforcement_level','field_provenance')) {
  if ($schema -notlike "*$field*") { Fail "trace_schema_missing_field: $field" }
}

$prov = Get-Content -Raw -Path (Join-Path $RepoRoot 'observability/trace-provenance-schema.md')
foreach ($label in @('runtime_observed','runner_validated','agent_declared','policy_inferred')) {
  if ($prov -notlike "*$label*") { Fail "trace_provenance_missing_label: $label" }
}

$closeTrace = Get-Content -Raw -Path (Join-Path $RepoRoot 'tools/close-trace.ps1')
foreach ($token in @('trace_artifact_refs_required','trace_evidence_refs_required','trace_unresolved_chat_ref')) {
  if ($closeTrace -notlike "*$token*") { Fail "trace_close_gate_missing: $token" }
}

$hookReport = Join-Path $RepoRoot 'traces/reports/hook-self-test.json'
if (-not (Test-Path -Path $hookReport)) {
  Fail 'trace_hook_self_test_missing'
}

$eventsFile = Join-Path $RepoRoot 'traces/local/events.jsonl'
if (Test-Path -Path $eventsFile) {
  $lineNo = 0
  foreach ($line in (Get-Content -Path $eventsFile)) {
    $lineNo += 1
    if (-not $line.Trim()) { continue }
    if ($line -notmatch '"trace_enforcement_level"' -or $line -notmatch '"field_provenance"') {
      Fail 'trace_event_missing_enforcement_or_provenance'
    }
    try {
      $event = $line | ConvertFrom-Json
    } catch {
      Fail "trace_event_invalid_json: line=$lineNo"
    }
    foreach ($field in @('artifact_refs','evidence_refs','checks_run')) {
      if ($null -eq $event.$field) { Fail "trace_event_missing_array_field: line=$lineNo field=$field" }
    }
    foreach ($field in @('artifact_refs','evidence_refs')) {
      foreach ($ref in @($event.$field)) {
        if (-not $ref) { Fail "trace_event_empty_ref: line=$lineNo field=$field" }
        if ([string]$ref -match '(?i)^chat:') { Fail "trace_event_unresolved_chat_ref: line=$lineNo field=$field" }
        if ([string]$ref -match '[,;]' -or [string]$ref -match "(`r|`n)") { Fail "trace_event_combined_or_multivalue_ref: line=$lineNo field=$field" }
        if ([string]$ref -match '(?i)^[A-Z]:[/\\]' -or [string]$ref -match '^(?i:/users/|/home/)') {
          Fail "trace_event_absolute_local_ref: line=$lineNo field=$field"
        }
      }
    }
    if ([string]$event.final_status -match '(?i)^[A-Z]:[/\\]' -or [string]$event.final_status -match '^(?i:/users/|/home/)') {
      Fail "trace_event_absolute_local_status: line=$lineNo"
    }
  }
}

Write-Host 'check-trace-coverage: ok'
