param(
  [switch]$Apply,
  [int]$Days = 30
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$cutoff = (Get-Date).AddDays(-1 * $Days)
$targets = Get-ChildItem -Path (Join-Path $RepoRoot 'traces') -Recurse -File |
  Where-Object { $_.Name -ne '.gitkeep' -and $_.LastWriteTime -lt $cutoff }

foreach ($file in $targets) {
  if ($Apply) {
    Remove-Item -Path $file.FullName -Force
    Write-Host "pruned: $($file.FullName)"
  } else {
    Write-Host "would_prune: $($file.FullName)"
  }
}
