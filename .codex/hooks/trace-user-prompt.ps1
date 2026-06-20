param([switch]$SelfTest)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$eventsPath = Join-Path $RepoRoot 'traces/state/hook-self-test-events.jsonl'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $eventsPath) | Out-Null

if ($SelfTest) {
  Add-Content -Path $eventsPath -Value '{"event":"user_prompt_submitted","source":"hook_self_test"}' -Encoding utf8
  exit 0
}

$inputText = [Console]::In.ReadToEnd()
$summary = if ([string]::IsNullOrWhiteSpace($inputText)) { 'no_stdin' } else { 'stdin_received_redacted_by_policy' }
Add-Content -Path $eventsPath -Value ('{"event":"user_prompt_submitted","source":"codex_hook","summary":"' + $summary + '"}') -Encoding utf8
