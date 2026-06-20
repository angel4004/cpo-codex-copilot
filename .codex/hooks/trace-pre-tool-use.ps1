param([switch]$SelfTest)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$eventsPath = Join-Path $RepoRoot 'traces/state/hook-self-test-events.jsonl'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $eventsPath) | Out-Null

if ($SelfTest) {
  Add-Content -Path $eventsPath -Value '{"event":"pre_tool_use","source":"hook_self_test"}' -Encoding utf8
  exit 0
}

[Console]::In.ReadToEnd() | Out-Null
Add-Content -Path $eventsPath -Value '{"event":"pre_tool_use","source":"codex_hook","summary":"tool_intent_seen"}' -Encoding utf8
