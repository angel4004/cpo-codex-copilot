$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$fixtureDir = Join-Path $RepoRoot 'evals/fixtures/redaction'
$outDir = Join-Path $RepoRoot 'traces/state/redaction-self-test'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$badPatterns = @(
  'sk-[A-Za-z0-9_\-]{8,}',
  '[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}',
  '\+?\d[\d\s().-]{7,}\d',
  'raw_transcript',
  'private_context'
)

foreach ($fixture in (Get-ChildItem -Path $fixtureDir -File)) {
  $out = Join-Path $outDir ($fixture.BaseName + '.redacted.txt')
  & (Join-Path $PSScriptRoot 'redact-trace-event.ps1') -InputPath $fixture.FullName -OutputPath $out
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  $text = Get-Content -Raw -Path $out
  foreach ($pattern in $badPatterns) {
    if ($text -match $pattern) {
      Write-Error "redaction_fixture_failed: $($fixture.Name) pattern=$pattern"
      exit 1
    }
  }
}

Write-Host 'check-redaction-fixtures: ok'
