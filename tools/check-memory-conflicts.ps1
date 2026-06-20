$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -Raw -Path (Join-Path $RepoRoot 'memory/MANIFEST.yaml')

$entries = @()
$blocks = [regex]::Matches($manifest, '(?ms)^\s*-\s+memory_id:\s*([^\r\n]+)(.*?)(?=^\s*-\s+memory_id:|\z)')
foreach ($b in $blocks) {
  $id = $b.Groups[1].Value.Trim()
  $body = $b.Groups[2].Value
  $claimsLine = ([regex]::Match($body, '(?m)^\s+claim_keys:\s*\[(.*?)\]')).Groups[1].Value
  $policy = ([regex]::Match($body, '(?m)^\s+conflict_policy:\s*(.+)$')).Groups[1].Value.Trim()
  foreach ($claim in ($claimsLine -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    $entries += [pscustomobject]@{ Id = $id; Claim = $claim; Policy = $policy }
  }
}

$conflicts = @()
foreach ($group in ($entries | Group-Object Claim)) {
  if ($group.Count -gt 1) {
    $policies = $group.Group | Select-Object -ExpandProperty Policy -Unique
    if ($policies -notcontains 'allow_local_overlay') {
      $conflicts += [pscustomobject]@{
        claim_key = $group.Name
        memory_ids = ($group.Group | Select-Object -ExpandProperty Id) -join ','
      }
    }
  }
}

if ($conflicts.Count -gt 0) {
  $reportDir = Join-Path $RepoRoot 'traces/reports'
  New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
  $report = Join-Path $reportDir 'memory-conflicts.json'
  $conflicts | ConvertTo-Json -Depth 4 | Set-Content -Path $report -Encoding utf8
  Write-Error "memory_conflict_detected: $report"
  exit 1
}

Write-Host 'check-memory-conflicts: ok'
