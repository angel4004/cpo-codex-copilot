$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $RepoRoot 'memory/MANIFEST.yaml'
$manifest = Get-Content -Raw -Path $manifestPath

function Fail($Message) {
  Write-Error $Message
  exit 1
}

$requiredFields = @('memory_id','path','authority','sensitivity','load_when','claim_keys','source_of_truth','freshness','owner')
foreach ($field in $requiredFields) {
  if ($manifest -notmatch "(?m)^\s*(?:-\s+)?${field}:") {
    Fail "memory_manifest_missing_field: $field"
  }
}

$paths = [regex]::Matches($manifest, '(?m)^\s+path:\s*(.+)$') | ForEach-Object { $_.Groups[1].Value.Trim() }
foreach ($rel in $paths) {
  if (-not (Test-Path -Path (Join-Path $RepoRoot $rel))) {
    Fail "memory_manifest_path_missing: $rel"
  }
}

$metadataFiles = @(
  'memory/shared/product-context.md',
  'memory/shared/methodology-context.md',
  'memory/shared/operating-principles.md',
  'memory/templates/local-user-profile.template.md',
  'memory/templates/local-project-context.template.md',
  'memory/templates/local-working-state.template.md'
)

foreach ($rel in $metadataFiles) {
  $text = Get-Content -Raw -Path (Join-Path $RepoRoot $rel)
  foreach ($field in @('owner','scope','authority','sensitivity','load_when','claim_keys','freshness')) {
    if ($text -notmatch "(?m)^${field}:") {
      Fail "memory_file_missing_metadata: $rel field=$field"
    }
  }
}

Write-Host 'check-memory-metadata: ok'
