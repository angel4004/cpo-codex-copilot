$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Fail($Message) {
  Write-Error $Message
  exit 1
}

$required = @(
  'AGENTS.md',
  'CONSTITUTION.md',
  'README.md',
  'CHANGELOG.md',
  'docs/live-validation.md',
  'ROUTING.yaml',
  'workflow-registry.yaml',
  'docs/runtime-contract.md',
  'memory/MANIFEST.yaml',
  'memory/shared/product-context.md',
  'memory/shared/methodology-context.md',
  'memory/shared/operating-principles.md',
  'memory/templates/local-user-profile.template.md',
  'memory/templates/local-project-context.template.md',
  'memory/templates/local-working-state.template.md',
  'migration/inventory.yaml',
  'observability/trace-schema.md',
  'observability/trace-provenance-schema.md',
  'observability/redaction-policy.md',
  'tools/check-live-validation-readiness.ps1',
  '.codex/hooks.json'
)

foreach ($rel in $required) {
  if (-not (Test-Path -Path (Join-Path $RepoRoot $rel))) {
    Fail "missing_required_path: $rel"
  }
}

$agents = Get-Content -Raw -Path (Join-Path $RepoRoot 'AGENTS.md')
foreach ($token in @('CONSTITUTION.md','docs/runtime-contract.md','workflow-registry.yaml','ROUTING.yaml','memory/MANIFEST.yaml')) {
  if ($agents -notlike "*$token*") {
    Fail "agents_bootloader_missing: $token"
  }
}

$runtime = Get-Content -Raw -Path (Join-Path $RepoRoot 'docs/runtime-contract.md')
foreach ($token in @('AGENTS.md','CONSTITUTION.md','trace_enforcement_level','prompt-level','local tools')) {
  if ($runtime -notlike "*$token*") {
    Fail "runtime_contract_missing: $token"
  }
}

& git -C $RepoRoot check-ignore -q 'memory/local/user-profile.md'
if ($LASTEXITCODE -ne 0) {
  Fail 'memory_local_not_ignored'
}

& git -C $RepoRoot check-ignore -q 'traces/local/events.jsonl'
if ($LASTEXITCODE -ne 0) {
  Fail 'traces_local_not_ignored'
}

Write-Host 'check-structure: ok'
