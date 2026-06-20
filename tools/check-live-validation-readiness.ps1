$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Fail($Message) {
  Write-Error $Message
  exit 1
}

$docPath = Join-Path $RepoRoot 'docs/live-validation.md'
if (-not (Test-Path -Path $docPath)) {
  Fail 'live_validation_doc_missing: docs/live-validation.md'
}

$doc = Get-Content -Raw -Path $docPath
foreach ($token in @(
  'adapter_status: connected',
  'live_api_status: protocol_live_pass_methodology_infra_blocked',
  'product_specific: false',
  'codex-copilot',
  'cpo-protocol-lab',
  'Salamander',
  'AGENTS.md',
  'current-contract replay',
  'infra blocked'
)) {
  if ($doc -notlike "*$token*") {
    Fail "live_validation_doc_missing_token: $token"
  }
}

$protocolCasePath = Join-Path $RepoRoot 'evals/protocol/protocol-lab-adapter-smoke.case.yaml'
if (-not (Test-Path -Path $protocolCasePath)) {
  Fail 'protocol_adapter_case_missing'
}

$protocolCase = Get-Content -Raw -Path $protocolCasePath
foreach ($token in @('description_ru:', 'prompt_ru:', 'expected_behavior_ru:', 'product-specific')) {
  if ($protocolCase -notlike "*$token*") {
    Fail "protocol_adapter_case_missing_token: $token"
  }
}

Write-Host 'check-live-validation-readiness: adapter_status=connected product_specific=false live_api_status=protocol_live_pass_methodology_infra_blocked'
