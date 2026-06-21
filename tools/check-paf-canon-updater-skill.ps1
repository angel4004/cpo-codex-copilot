$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Fail($Message) {
  Write-Error $Message
  exit 1
}

$skillRoot = Join-Path $RepoRoot 'skill-candidates/paf-canon-updater'
$required = @(
  'SKILL.md',
  'agents/openai.yaml',
  'references/source-policy.md',
  'references/update-workflow.md',
  'references/eval-and-readiness.md',
  'sources/paf-source-registry.yaml',
  'scripts/check-paf-source-registry.ps1',
  'scripts/discover-paf-site-links.ps1'
)

foreach ($rel in $required) {
  if (-not (Test-Path -Path (Join-Path $skillRoot $rel))) {
    Fail "paf_canon_updater_missing: $rel"
  }
}

$skill = Get-Content -Raw -Path (Join-Path $skillRoot 'SKILL.md')
foreach ($token in @(
  'name: paf-canon-updater',
  'Use when',
  'productframework.ru',
  'proposal-first',
  'references/source-policy.md',
  'references/update-workflow.md',
  'sources/paf-source-registry.yaml'
)) {
  if ($skill -notlike "*$token*") {
    Fail "paf_canon_updater_skill_missing_token: $token"
  }
}

$policy = Get-Content -Raw -Path (Join-Path $skillRoot 'references/source-policy.md')
foreach ($token in @(
  'official_paf',
  'candidate_context',
  'boroda_producta',
  'not_canonical_source',
  'raw private content'
)) {
  if ($policy -notlike "*$token*") {
    Fail "paf_canon_updater_policy_missing_token: $token"
  }
}

$workflow = Get-Content -Raw -Path (Join-Path $skillRoot 'references/update-workflow.md')
foreach ($token in @(
  'source freshness',
  'delta classification',
  'canonical update proposal',
  'paf_consistency_review',
  'human approval'
)) {
  if ($workflow -notlike "*$token*") {
    Fail "paf_canon_updater_workflow_missing_token: $token"
  }
}

$registry = Get-Content -Raw -Path (Join-Path $skillRoot 'sources/paf-source-registry.yaml')
foreach ($token in @(
  'https://productframework.ru/ops/main',
  'authority: official_paf',
  'authority: candidate_context',
  'canonical_allowed: false',
  'requires_human_review: true'
)) {
  if ($registry -notlike "*$token*") {
    Fail "paf_canon_updater_registry_missing_token: $token"
  }
}

& (Join-Path $skillRoot 'scripts/check-paf-source-registry.ps1')
if ($LASTEXITCODE -ne 0) {
  Fail 'paf_canon_updater_registry_check_failed'
}

Write-Host 'check-paf-canon-updater-skill: ok'
