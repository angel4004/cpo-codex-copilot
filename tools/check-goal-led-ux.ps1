$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Read-RepoText {
  param([Parameter(Mandatory = $true)] [string] $RelativePath)
  return Get-Content -LiteralPath (Join-Path $RepoRoot $RelativePath) -Raw -Encoding UTF8
}

function Assert-Contains {
  param(
    [Parameter(Mandatory = $true)] [string] $Name,
    [Parameter(Mandatory = $true)] [string] $Text,
    [Parameter(Mandatory = $true)] [string] $Needle
  )
  if (-not $Text.Contains($Needle)) {
    throw "goal_led_ux_missing: $Name must contain '$Needle'"
  }
}

function Assert-RouteContains {
  param(
    [Parameter(Mandatory = $true)] [string] $RouteId,
    [Parameter(Mandatory = $true)] [string] $Needle
  )
  $routing = Read-RepoText 'ROUTING.yaml'
  $pattern = "(?ms)task_type:\s+$([regex]::Escape($RouteId))\b.*?(?=\n\s+-\s+task_type:|\z)"
  $match = [regex]::Match($routing, $pattern)
  if (-not $match.Success) {
    throw "goal_led_ux_route_missing: $RouteId"
  }
  if (-not $match.Value.Contains($Needle)) {
    throw "goal_led_ux_route_missing: $RouteId must contain '$Needle'"
  }
}

function Text-FromBase64 {
  param([Parameter(Mandatory = $true)] [string] $Value)
  return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Value))
}

$requiredFiles = @(
  'AGENTS.md',
  'CONSTITUTION.md',
  'ROUTING.yaml',
  'practices/copilot-ux/dialogue-first.md',
  'practices/copilot-ux/goal-led-validation.md',
  'workflows/activation/activate-cpo-copilot.md',
  'workflows/onboarding/create-project-passport.md',
  'workflows/reviews/evidence-gap-review.md'
)

foreach ($path in $requiredFiles) {
  if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot $path))) {
    throw "goal_led_ux_file_missing: $path"
  }
}

$joined = ($requiredFiles | ForEach-Object { Read-RepoText $_ }) -join "`n---`n"
foreach ($needle in @(
  (Text-FromBase64 '0JrQsNGA0YLQsCDRhtC10LvQuA=='),
  (Text-FromBase64 '0JzQsNGA0YjRgNGD0YLQuNC30LDRhtC40Y8g0LjRgdGC0L7Rh9C90LjQutC+0LI='),
  (Text-FromBase64 '0J/RgNC+0LLQtdGA0LrQsCDQtNC+0LrQsNC30LDRgtC10LvRjNC90L7RgdGC0Lg='),
  (Text-FromBase64 '0KHQu9C10LTRg9GO0YnQuNC5INC/0YDQvtCy0LXRgNC+0YfQvdGL0Lkg0LDRgNGC0LXRhNCw0LrRgg=='),
  (Text-FromBase64 '0KDQtdGI0LXQvdC40LUg0L/QvtGB0LvQtSDQv9GA0L7QstC10YDQutC4'),
  (Text-FromBase64 '0JrRgNCw0YLQutC+0YHRgtGMINC/0L4g0YPQvNC+0LvRh9Cw0L3QuNGO'),
  (Text-FromBase64 '0L3QtSDQsdC+0LvRjNGI0LUg0YLRgNC10YUg0LLQvtC/0YDQvtGB0L7Qsg=='),
  'Artifact Inventory Gate',
  'Passport Registry',
  'validation loop',
  'Project passport must not be first artifact',
  'forbidden in first new-product response',
  'Copilot owns the next step'
)) {
  Assert-Contains -Name 'goal-led runtime docs' -Text $joined -Needle $needle
}

Assert-RouteContains -RouteId 'goal_validation' -Needle 'evidence_gap_review'
Assert-RouteContains -RouteId 'goal_validation' -Needle 'practices/copilot-ux/goal-led-validation.md'
Assert-RouteContains -RouteId 'goal_validation' -Needle 'check-paf-enforcement'

$runSmoke = Read-RepoText 'tools/run-smoke.ps1'
Assert-Contains -Name 'tools/run-smoke.ps1' -Text $runSmoke -Needle 'check-goal-led-ux.ps1'

Write-Host 'check-goal-led-ux: ok'
