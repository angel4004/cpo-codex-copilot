param(
  [string]$EventJson,
  [string]$EventPath,
  [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
if (-not $OutputPath) { $OutputPath = Join-Path $RepoRoot 'traces/local/events.jsonl' }

if ($EventPath) {
  $json = Get-Content -Raw -Path $EventPath
} elseif ($EventJson) {
  $json = $EventJson
} else {
  $json = [Console]::In.ReadToEnd()
}

foreach ($token in @('raw_prompt','raw_tool_args','raw_tool_output','private_context','raw_transcript')) {
  if ($json -match [regex]::Escape($token)) {
    Write-Error "trace_redaction_failed: forbidden_field=$token"
    exit 1
  }
}

foreach ($pattern in @('sk-[A-Za-z0-9_\-]{8,}','[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}')) {
  if ($json -match $pattern) {
    Write-Error "trace_redaction_failed: sensitive_pattern=$pattern"
    exit 1
  }
}

foreach ($required in @('trace_id','session_id','trace_enforcement_level','field_provenance')) {
  if ($json -notmatch '"' + $required + '"') {
    Write-Error "trace_event_missing_field: $required"
    exit 1
  }
}

$dir = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Add-Content -Path $OutputPath -Value ($json.Trim()) -Encoding utf8
Write-Host "write-trace-event: ok $OutputPath"
