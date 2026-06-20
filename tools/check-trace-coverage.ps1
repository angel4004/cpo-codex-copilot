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

$hookReport = Join-Path $RepoRoot 'traces/reports/hook-self-test.json'
if (-not (Test-Path -Path $hookReport)) {
  Fail 'trace_hook_self_test_missing'
}

$eventsFile = Join-Path $RepoRoot 'traces/local/events.jsonl'
if (Test-Path -Path $eventsFile) {
  foreach ($line in (Get-Content -Path $eventsFile)) {
    if ($line -notmatch '"trace_enforcement_level"' -or $line -notmatch '"field_provenance"') {
      Fail 'trace_event_missing_enforcement_or_provenance'
    }
  }
}

Write-Host 'check-trace-coverage: ok'
