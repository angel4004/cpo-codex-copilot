param(
  [Parameter(Mandatory=$true)][string]$Message
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

& (Join-Path $PSScriptRoot 'run-smoke.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$canonical = @('AGENTS.md','CONSTITUTION.md','ROUTING.yaml','workflow-registry.yaml','memory/','practices/','workflows/','skill-candidates/','evals/','observability/','migration/','tools/')
$staged = & git -C $RepoRoot diff --cached --name-only
$touchedCanonical = @()
foreach ($file in $staged) {
  foreach ($prefix in $canonical) {
    if ($file -eq $prefix -or $file.StartsWith($prefix)) { $touchedCanonical += $file }
  }
}

if ($touchedCanonical.Count -gt 0 -and -not (Test-Path -Path (Join-Path $RepoRoot 'traces/local/events.jsonl'))) {
  Write-Error 'commit_gate_missing_trace'
  exit 1
}

& git -C $RepoRoot commit -m $Message
exit $LASTEXITCODE
