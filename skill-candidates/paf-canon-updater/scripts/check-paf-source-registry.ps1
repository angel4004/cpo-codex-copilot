$ErrorActionPreference = 'Stop'
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillRoot = Split-Path -Parent $ScriptRoot
$RegistryPath = Join-Path $SkillRoot 'sources/paf-source-registry.yaml'

function Fail($Message) {
  Write-Error $Message
  exit 1
}

if (-not (Test-Path -Path $RegistryPath)) {
  Fail 'paf_source_registry_missing'
}

$registry = Get-Content -Raw -Path $RegistryPath

foreach ($token in @(
  'schema_version:',
  'sources:',
  'https://productframework.ru/ops/main',
  'authority: official_paf',
  'authority: official_paf_index',
  'authority: candidate_context',
  'canonical_allowed: false',
  'requires_human_review: true'
)) {
  if ($registry -notlike "*$token*") {
    Fail "paf_source_registry_missing_token: $token"
  }
}

$ids = [regex]::Matches($registry, '(?m)^\s+-\s+source_id:\s*([a-z0-9_:-]+)\s*$') |
  ForEach-Object { $_.Groups[1].Value.Trim() }

if ($ids.Count -eq 0) {
  Fail 'paf_source_registry_no_sources'
}

$duplicateIds = $ids | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicateIds.Count -gt 0) {
  Fail "paf_source_registry_duplicate_ids: $($duplicateIds.Name -join ',')"
}

$blocks = [regex]::Matches($registry, '(?ms)^\s*-\s+source_id:\s*([^\r\n]+)(.*?)(?=^\s*-\s+source_id:|\z)')
foreach ($block in $blocks) {
  $sourceId = $block.Groups[1].Value.Trim()
  $body = $block.Groups[2].Value
  foreach ($field in @('url','authority','canonical_allowed','requires_human_review','monitor','claim_keys')) {
    if ($body -notmatch "(?m)^\s+${field}:") {
      Fail "paf_source_registry_missing_field: $sourceId field=$field"
    }
  }

  $authority = ([regex]::Match($body, '(?m)^\s+authority:\s*(\S+)')).Groups[1].Value.Trim()
  if (@('official_paf','official_paf_index','author_public_channel','candidate_context') -notcontains $authority) {
    Fail "paf_source_registry_unknown_authority: $sourceId authority=$authority"
  }

  if ($authority -ne 'official_paf' -and $body -match '(?m)^\s+canonical_allowed:\s*true\s*$') {
    Fail "paf_source_registry_non_official_canonical: $sourceId"
  }

  if ($authority -in @('author_public_channel','candidate_context')) {
    if ($body -notmatch '(?m)^\s+canonical_allowed:\s*false\s*$') {
      Fail "paf_source_registry_candidate_must_not_be_canonical: $sourceId"
    }
    if ($body -notmatch '(?m)^\s+requires_human_review:\s*true\s*$') {
      Fail "paf_source_registry_candidate_requires_review: $sourceId"
    }
  }
}

Write-Host 'check-paf-source-registry: ok'
exit 0
