$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$failed = $false

$files = Get-ChildItem -Path $RepoRoot -Recurse -File -Include *.md |
  Where-Object { $_.FullName -notmatch '\\.git\\' }

foreach ($file in $files) {
  $text = Get-Content -Raw -Path $file.FullName
  $matches = [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')
  foreach ($m in $matches) {
    $target = $m.Groups[1].Value.Trim()
    if ($target -match '^(https?|mailto|#|artifact:)' -or $target -eq '') { continue }
    $target = $target.Trim('<','>')
    $target = ($target -split '#')[0]
    if ($target -eq '') { continue }
    $candidate = Join-Path $file.Directory.FullName $target
    if (-not (Test-Path -Path $candidate)) {
      Write-Error "broken_markdown_link: $($file.FullName) -> $target"
      $failed = $true
    }
  }
}

if ($failed) { exit 1 }
Write-Host 'check-links: ok'
