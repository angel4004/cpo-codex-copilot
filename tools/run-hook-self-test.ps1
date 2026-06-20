$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$eventsPath = Join-Path $RepoRoot 'traces/state/hook-self-test-events.jsonl'
if (Test-Path -Path $eventsPath) { Remove-Item -Path $eventsPath -Force }

$hooks = @(
  '.codex/hooks/trace-user-prompt.ps1',
  '.codex/hooks/trace-pre-tool-use.ps1',
  '.codex/hooks/trace-post-tool-use.ps1',
  '.codex/hooks/trace-stop.ps1'
)

foreach ($hook in $hooks) {
  & (Join-Path $RepoRoot $hook) -SelfTest
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$events = if (Test-Path -Path $eventsPath) { Get-Content -Path $eventsPath } else { @() }
$expected = @('user_prompt_submitted','pre_tool_use','post_tool_use','stop')
$missing = @()
foreach ($event in $expected) {
  if (-not ($events -match $event)) { $missing += $event }
}

$status = if ($missing.Count -eq 0) { 'trace_enforcement_disabled' } else { 'trace_hook_sequence_incomplete' }
$report = [ordered]@{
  status = $status
  trace_enforcement_level = 'runner_only'
  live_hook_verified = $false
  reason = 'Self-test invoked hook scripts directly; live Codex hook dispatch cannot be proven from a shell run.'
  missing_events = $missing
  events_path = 'traces/state/hook-self-test-events.jsonl'
}

$reportPath = Join-Path $RepoRoot 'traces/reports/hook-self-test.json'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $reportPath) | Out-Null
$report | ConvertTo-Json -Depth 5 | Set-Content -Path $reportPath -Encoding utf8
Write-Host "run-hook-self-test: $status level=runner_only live_hook_verified=false"
