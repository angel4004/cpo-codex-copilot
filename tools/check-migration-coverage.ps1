$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$WorkspaceRoot = Split-Path -Parent $RepoRoot
$inventoryPath = Join-Path $RepoRoot 'migration/inventory.yaml'
$inventory = Get-Content -Raw -Path $inventoryPath
$valid = @('keep-as-practice','convert-to-workflow','split','move-to-memory','turn-into-eval','candidate-for-skill','retire')
$requiresDestination = @('keep-as-practice','convert-to-workflow','split','move-to-memory','turn-into-eval','candidate-for-skill')

function Fail($Message) {
  Write-Error $Message
  exit 1
}

$sourceFiles = @()
$sourceFiles += Get-ChildItem -Path (Join-Path $WorkspaceRoot 'cpo/runtime/core') -Recurse -File -Filter '*.md'
$sourceFiles += Get-ChildItem -Path (Join-Path $WorkspaceRoot 'cpo/runtime/project_setup') -Recurse -File -Filter '*.md'

foreach ($file in $sourceFiles) {
  $rel = $file.FullName.Substring($WorkspaceRoot.Length + 1).Replace('\','/')
  if ($inventory -notlike "*$rel*") {
    Fail "migration_source_missing: $rel"
  }
}

$blocks = [regex]::Matches($inventory, '(?ms)^\s*-\s+source_file:\s*([^\r\n]+)(.*?)(?=^\s*-\s+source_file:|\z)')
if ($blocks.Count -ne $sourceFiles.Count) {
  Fail "migration_inventory_count_mismatch: inventory=$($blocks.Count) source=$($sourceFiles.Count)"
}

foreach ($block in $blocks) {
  $source = $block.Groups[1].Value.Trim()
  $body = $block.Groups[2].Value
  foreach ($field in @('source_sha','current_role','classification','new_destination','migration_notes','quality_risk','owner','status','verification_refs')) {
    if ($body -notmatch "(?m)^\s+${field}:\s*(.+)$") {
      Fail "migration_item_missing_field: $source field=$field"
    }
  }
  $classification = ([regex]::Match($body, '(?m)^\s+classification:\s*(\S+)')).Groups[1].Value.Trim()
  if ($valid -notcontains $classification) {
    Fail "migration_invalid_classification: $source classification=$classification"
  }
  $dest = ([regex]::Match($body, '(?m)^\s+new_destination:\s*(.+)$')).Groups[1].Value.Trim()
  if (($requiresDestination -contains $classification) -and [string]::IsNullOrWhiteSpace($dest)) {
    Fail "migration_destination_missing: $source"
  }
}

Write-Host 'check-migration-coverage: ok'
