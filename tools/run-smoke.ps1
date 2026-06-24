$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

$commands = @(
  'run-hook-self-test.ps1',
  'check-structure.ps1',
  'check-links.ps1',
  'check-language.ps1',
  'check-activation-ux.ps1',
  'check-memory-metadata.ps1',
  'check-memory-conflicts.ps1',
  'check-routing.ps1',
  'check-eval-schema.ps1',
  'check-live-validation-readiness.ps1',
  'check-redaction-fixtures.ps1',
  'check-trace-coverage.ps1',
  'check-paf-enforcement.ps1',
  'check-migration-coverage.ps1'
)

foreach ($cmd in $commands) {
  Write-Host "RUN $cmd"
  & (Join-Path $PSScriptRoot $cmd)
  if ($LASTEXITCODE -ne 0) {
    Write-Error "smoke_failed: $cmd"
    exit $LASTEXITCODE
  }
}

Write-Host 'run-smoke: ok'
