param(
  [string]$InputPath,
  [string]$OutputPath,
  [string]$Text
)

$ErrorActionPreference = 'Stop'

if ($InputPath) {
  $content = Get-Content -Raw -Path $InputPath
} elseif ($Text) {
  $content = $Text
} else {
  $content = [Console]::In.ReadToEnd()
}

$content = $content -replace 'sk-[A-Za-z0-9_\-]{8,}', '[REDACTED_SECRET]'
$content = $content -replace '(?i)(OPENAI_API_KEY|ANTHROPIC_API_KEY|API_KEY|TOKEN|SECRET)\s*=\s*[^\s]+', '$1=[REDACTED_SECRET]'
$content = $content -replace '[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}', '[REDACTED_EMAIL]'
$content = $content -replace '\+?\d[\d\s().-]{7,}\d', '[REDACTED_PHONE]'
$content = $content -replace '(?is)raw_transcript\s*:\s*.*', '[REDACTED_TRANSCRIPT]'
$content = $content -replace '(?is)private_context\s*:\s*.*', '[REDACTED_LOCAL_DATA]'
$content = $content -replace '(?is)"raw_prompt"\s*:\s*"[^"]*"', '"redacted_prompt_ref":"[REDACTED]"'
$content = $content -replace '(?is)"raw_tool_args"\s*:\s*({.*?}|"[^"]*")', '"redacted_tool_args_ref":"[REDACTED]"'
$content = $content -replace '(?is)"raw_tool_output"\s*:\s*({.*?}|"[^"]*")', '"redacted_tool_output_ref":"[REDACTED]"'

if ($OutputPath) {
  $dir = Split-Path -Parent $OutputPath
  if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  Set-Content -Path $OutputPath -Value $content -Encoding utf8
} else {
  Write-Output $content
}
