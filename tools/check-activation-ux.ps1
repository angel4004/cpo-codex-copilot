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
    throw "activation_ux_missing: $Name must contain '$Needle'"
  }
}

function Assert-NotContains {
  param(
    [Parameter(Mandatory = $true)] [string] $Name,
    [Parameter(Mandatory = $true)] [string] $Text,
    [Parameter(Mandatory = $true)] [string] $Needle
  )
  if ($Text.Contains($Needle)) {
    throw "activation_ux_forbidden: $Name must not contain '$Needle'"
  }
}

$activationFiles = @(
  'AGENTS.md',
  'workflows/activation/activate-cpo-copilot.md',
  'README.md',
  'docs/install.md'
)

function Text-FromBase64 {
  param([Parameter(Mandatory = $true)] [string] $Value)
  return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Value))
}

$launchNew = Text-FromBase64 '0JfQsNC/0YPRgdGC0LjRgtGMINC90L7QstGL0Lkg0L/RgNC+0LTRg9C60YIg0LjQu9C4INC90LDQv9GA0LDQstC70LXQvdC40LU='
$improveCurrent = Text-FromBase64 '0KDQsNC30LLQuNCy0LDRgtGMINGC0LXQutGD0YnQuNC5INC/0YDQvtC00YPQutGC'
$prepareStep = Text-FromBase64 '0J/QvtC00LPQvtGC0L7QstC40YLRjCDQv9GA0L7QtNGD0LrRgtC+0LLRi9C5INGI0LDQsw=='
$disputedClaim = Text-FromBase64 '0KDQsNC30L7QsdGA0LDRgtGMINGB0L/QvtGA0L3Ri9C5INCy0YvQstC+0LQ='
$freeForm = ([char]0x043D + [char]0x0430 + [char]0x043F + [char]0x0438 + [char]0x0448 + [char]0x0438 + ' ' + [char]0x0441 + [char]0x0432 + [char]0x043E + [char]0x0438 + [char]0x043C + [char]0x0438 + ' ' + [char]0x0441 + [char]0x043B + [char]0x043E + [char]0x0432 + [char]0x0430 + [char]0x043C + [char]0x0438)
$oldProductNoPassport = Text-FromBase64 '0JXRgdGC0Ywg0L/RgNC+0LTRg9C60YIsINC/0LDRgdC/0L7RgNGC0LAg0L3QtdGC'
$oldProductAndPassport = Text-FromBase64 '0JXRgdGC0Ywg0L/RgNC+0LTRg9C60YIg0Lgg0L/QsNGB0L/QvtGA0YI='
$oldNoProduct = Text-FromBase64 '0J/RgNC+0LTRg9C60YLQsCDQvdC10YI='
$oldSpecificQuestion = Text-FromBase64 '0JXRgdGC0Ywg0LrQvtC90LrRgNC10YLQvdGL0Lkg0LLQvtC/0YDQvtGB'
$oldCollectPassport = Text-FromBase64 '0YHQvtCx0YDQsNGC0Ywg0L/QtdGA0LLRi9C5INC/0LDRgdC/0L7RgNGCINC/0YDQvtC10LrRgtCw'
$oldStrengthenPassport = Text-FromBase64 '0L/RgNC+0LLQtdGA0LjRgtGMINC40LvQuCDRg9GB0LjQu9C40YLRjCDQv9Cw0YHQv9C+0YDRgg=='
$oldProductAxis = ([char]0x0423 + ' ' + [char]0x043C + [char]0x0435 + [char]0x043D + [char]0x044F + ' ' + [char]0x0435 + [char]0x0441 + [char]0x0442 + [char]0x044C + ' ' + [char]0x043F + [char]0x0440 + [char]0x043E + [char]0x0434 + [char]0x0443 + [char]0x043A + [char]0x0442 + ' / ' + [char]0x0423 + ' ' + [char]0x043C + [char]0x0435 + [char]0x043D + [char]0x044F + ' ' + [char]0x043D + [char]0x0435 + [char]0x0442 + ' ' + [char]0x043F + [char]0x0440 + [char]0x043E + [char]0x0434 + [char]0x0443 + [char]0x043A + [char]0x0442 + [char]0x0430)
$oldPassportAxis = ([char]0x0423 + ' ' + [char]0x043C + [char]0x0435 + [char]0x043D + [char]0x044F + ' ' + [char]0x0435 + [char]0x0441 + [char]0x0442 + [char]0x044C + ' ' + [char]0x043F + [char]0x0430 + [char]0x0441 + [char]0x043F + [char]0x043E + [char]0x0440 + [char]0x0442 + ' / ' + [char]0x0423 + ' ' + [char]0x043C + [char]0x0435 + [char]0x043D + [char]0x044F + ' ' + [char]0x043D + [char]0x0435 + [char]0x0442 + ' ' + [char]0x043F + [char]0x0430 + [char]0x0441 + [char]0x043F + [char]0x043E + [char]0x0440 + [char]0x0442 + [char]0x0430)
$oldIHavePrefix = ([char]0x0423 + ' ' + [char]0x043C + [char]0x0435 + [char]0x043D + [char]0x044F + ' ')
$oldTaskLabel = ([char]0x0417 + [char]0x0430 + [char]0x0434 + [char]0x0430 + [char]0x0447 + [char]0x0430 + ':')
$oldTaskPlaceholder = ($oldTaskLabel + ' ...')

foreach ($path in $activationFiles) {
  $text = Read-RepoText $path
  Assert-Contains -Name $path -Text $text -Needle $launchNew
  Assert-Contains -Name $path -Text $text -Needle $improveCurrent
  Assert-Contains -Name $path -Text $text -Needle $prepareStep
  Assert-Contains -Name $path -Text $text -Needle $disputedClaim
  Assert-Contains -Name $path -Text $text -Needle $freeForm
  if ($path -eq 'AGENTS.md' -or $path -eq 'workflows/activation/activate-cpo-copilot.md') {
    Assert-Contains -Name $path -Text $text -Needle 'Do not say workflow in activation output'
  }
  Assert-NotContains -Name $path -Text $text -Needle 'review/hardening'
  Assert-NotContains -Name $path -Text $text -Needle '- evidence gap review;'
  Assert-NotContains -Name $path -Text $text -Needle '- PAF consistency review.'
  Assert-NotContains -Name $path -Text $text -Needle $oldProductNoPassport
  Assert-NotContains -Name $path -Text $text -Needle $oldProductAndPassport
  Assert-NotContains -Name $path -Text $text -Needle $oldNoProduct
  Assert-NotContains -Name $path -Text $text -Needle $oldSpecificQuestion
  Assert-NotContains -Name $path -Text $text -Needle $oldCollectPassport
  Assert-NotContains -Name $path -Text $text -Needle $oldStrengthenPassport
  Assert-NotContains -Name $path -Text $text -Needle $oldProductAxis
  Assert-NotContains -Name $path -Text $text -Needle $oldPassportAxis
  Assert-NotContains -Name $path -Text $text -Needle $oldTaskPlaceholder
}

$productContext = Read-RepoText 'memory/shared/product-context.md'
Assert-Contains -Name 'memory/shared/product-context.md' -Text $productContext -Needle $launchNew
Assert-Contains -Name 'memory/shared/product-context.md' -Text $productContext -Needle $improveCurrent
Assert-Contains -Name 'memory/shared/product-context.md' -Text $productContext -Needle $prepareStep
Assert-Contains -Name 'memory/shared/product-context.md' -Text $productContext -Needle $disputedClaim

$behaviorFiles = Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'evals/behavior') -Filter '*.yaml' -File
foreach ($file in $behaviorFiles) {
  $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
  if (-not ($text.Contains($launchNew) -or $text.Contains($improveCurrent) -or $text.Contains($prepareStep) -or $text.Contains($disputedClaim))) {
    throw "activation_ux_missing_hybrid_task_context: $($file.Name)"
  }
  Assert-NotContains -Name $file.Name -Text $text -Needle $oldProductNoPassport
  Assert-NotContains -Name $file.Name -Text $text -Needle $oldProductAndPassport
  Assert-NotContains -Name $file.Name -Text $text -Needle $oldNoProduct
  Assert-NotContains -Name $file.Name -Text $text -Needle $oldSpecificQuestion
  Assert-NotContains -Name $file.Name -Text $text -Needle $oldIHavePrefix
  Assert-NotContains -Name $file.Name -Text $text -Needle $oldTaskLabel
}

Write-Host 'check-activation-ux: ok'
