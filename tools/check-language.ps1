$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Fail($Message) {
  Write-Error $Message
  exit 1
}

function Get-RepoRelativePath($Path) {
  return [System.IO.Path]::GetFullPath($Path).Substring($RepoRoot.Length + 1).Replace('\', '/')
}

$humanFiles = Get-ChildItem -Path $RepoRoot -Recurse -File -Include '*.md','*.yaml' |
  Where-Object {
    $_.FullName -notmatch '\\.git\\' -and
    $_.FullName -notmatch '\\traces\\' -and
    $_.FullName -notmatch '\\evals\\fixtures\\'
  }

$englishOnlyHeading = '^(#{1,6}\s+)([A-Za-z][A-Za-z0-9 .:/()&+-]*[A-Za-z0-9)]?)\s*$'
$visibleYamlField = '^\s*(title|description|description_ru|prompt_ru|expected_behavior_ru|human_title|summary|goal|status_note):\s*(.+?)\s*$'

foreach ($file in $humanFiles) {
  $rel = Get-RepoRelativePath $file.FullName
  $text = Get-Content -Raw -Path $file.FullName

  if ($text -notmatch '\p{IsCyrillic}') {
    Fail "language_no_cyrillic: $rel"
  }

  $inCodeBlock = $false
  $lineNumber = 0
  foreach ($line in ($text -split "`r?`n")) {
    $lineNumber += 1
    if ($line -match '^\s*```') {
      $inCodeBlock = -not $inCodeBlock
      continue
    }
    if ($inCodeBlock) {
      continue
    }

    if ($line -match $englishOnlyHeading) {
      Fail "language_english_heading: $rel line=$lineNumber text=$($line.Trim())"
    }

    if ($line -match $visibleYamlField) {
      $value = $Matches[2]
      if ($value -match '[A-Za-z]' -and $value -notmatch '\p{IsCyrillic}') {
        Fail "language_english_visible_yaml: $rel line=$lineNumber text=$($line.Trim())"
      }
    }
  }
}

Write-Host 'check-language: ok'
