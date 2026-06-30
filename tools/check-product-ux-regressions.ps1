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
    throw ("product_ux_regression_missing: {0} must contain [{1}]" -f $Name, $Needle)
  }
}

function Assert-NotContains {
  param(
    [Parameter(Mandatory = $true)] [string] $Name,
    [Parameter(Mandatory = $true)] [string] $Text,
    [Parameter(Mandatory = $true)] [string] $Needle
  )
  if ($Text.Contains($Needle)) {
    throw ("product_ux_regression_forbidden: {0} must not contain [{1}]" -f $Name, $Needle)
  }
}

function Text-FromBase64 {
  param([Parameter(Mandatory = $true)] [string] $Value)
  return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Value))
}

$goalCard = Text-FromBase64 '0JrQsNGA0YLQsCDRhtC10LvQuA=='
$sourceRouting = Text-FromBase64 '0JzQsNGA0YjRgNGD0YLQuNC30LDRhtC40Y8g0LjRgdGC0L7Rh9C90LjQutC+0LI='
$evidenceCheck = Text-FromBase64 '0J/RgNC+0LLQtdGA0LrQsCDQtNC+0LrQsNC30LDRgtC10LvRjNC90L7RgdGC0Lg='
$nextArtifact = Text-FromBase64 '0KHQu9C10LTRg9GO0YnQuNC5INC/0YDQvtCy0LXRgNC+0YfQvdGL0Lkg0LDRgNGC0LXRhNCw0LrRgg=='
$decisionAfter = Text-FromBase64 '0KDQtdGI0LXQvdC40LUg0L/QvtGB0LvQtSDQv9GA0L7QstC10YDQutC4'
$defaultBriefness = Text-FromBase64 '0JrRgNCw0YLQutC+0YHRgtGMINC/0L4g0YPQvNC+0LvRh9Cw0L3QuNGO'
$maxThreeQuestions = Text-FromBase64 '0L3QtSDQsdC+0LvRjNGI0LUg0YLRgNC10YUg0LLQvtC/0YDQvtGB0L7Qsg=='
$clientFeedback = Text-FromBase64 '0JrQu9C40LXQvdGC0YHQutC40Lkg0YTQuNC00LHQtdC6'
$feedbackDecision = Text-FromBase64 '0YfRgtC+INGB0LTQtdC70LDRgtGMINGBINGN0YLQuNC8INGE0LjQtNCx0LXQutC+0Lw='
$fullScenarioFrame = Text-FromBase64 '0YXQvtGA0L7RiNC+IC8g0L/Qu9C+0YXQviAvINC80L7QttC90L4g0YPQu9GD0YfRiNC40YLRjA=='
$uiNotChecked = Text-FromBase64 '0LDQutGC0YPQsNC70YzQvdGL0Lkg0LjQvdGC0LXRgNGE0LXQudGBINC90LUg0L/RgNC+0LLQtdGA0LXQvQ=='
$notReadyHandoff = Text-FromBase64 '0L3QtSDQvdCw0LfRi9Cy0LDQuSBoYW5kb2ZmINCz0L7RgtC+0LLRi9C8'
$noLongPafGoalTemplate = Text-FromBase64 '0L3QtSDQstGL0LTQsNC10YIg0LTQu9C40L3QvdGL0LkgUEFGL0dvYWwgQ2FyZCDRiNCw0LHQu9C+0L0='
$currentUi = Text-FromBase64 '0LDQutGC0YPQsNC70YzQvdGL0Lkg0LjQvdGC0LXRgNGE0LXQudGB'
$russianUserFacing = Text-FromBase64 '0YDRg9GB0YHQutC+0Y/Qt9GL0YfQvdGL0Lk='
$briefness = Text-FromBase64 '0LrRgNCw0YLQutC+0YHRgtGM'
$anglicisms = Text-FromBase64 '0LDQvdCz0LvQuNGG0LjQt9C80Ys='
$firstStep = Text-FromBase64 '0J/QtdGA0LLRi9C5INGI0LDQsw=='
$visiblePafCheck = Text-FromBase64 '0J/RgNC+0LLQtdGA0LrQsCDQtNC+0LrQsNC30LDRgtC10LvRjNC90L7RgdGC0LggKFBBRik='
$evidenceLevel = Text-FromBase64 '0YPRgNC+0LLQtdC90Ywg0LTQvtC60LDQt9Cw0YLQtdC70YzRgdGC0LI='
$canTake = Text-FromBase64 '0JzQvtCz0YMg0LLQt9GP0YLRjA=='
$willCheck = Text-FromBase64 '0J/RgNC+0LLQtdGA0Y4g0YHQsNC8'
$nextArtifactShort = Text-FromBase64 '0KHQu9C10LTRg9GO0YnQuNC5INCw0YDRgtC10YTQsNC60YI='
$attribution = Text-FromBase64 '0LDRgtGA0LjQsdGD0YbQuNGP'
$channel = Text-FromBase64 '0LrQsNC90LDQuw=='
$moment = Text-FromBase64 '0LzQvtC80LXQvdGC'
$handoff = Text-FromBase64 'aGFuZG9mZg=='
$evidenceRu = Text-FromBase64 '0JTQvtC60LDQt9Cw0YLQtdC70YzRgdGC0LLQsA=='
$missingRu = Text-FromBase64 '0J3QtSDRhdCy0LDRgtCw0LXRgg=='
$cannotClaimRu = Text-FromBase64 '0J3QtdC70YzQt9GPINGD0YLQstC10YDQttC00LDRgtGM'
$nextStepRu = Text-FromBase64 '0KHQu9C10LTRg9GO0YnQuNC5INGI0LDQsw=='
$whatIsCloser = ([char]0x0427 + [char]0x0442 + [char]0x043E + ' ' + [char]0x0441 + [char]0x0435 + [char]0x0439 + [char]0x0447 + [char]0x0430 + [char]0x0441 + ' ' + [char]0x0431 + [char]0x043B + [char]0x0438 + [char]0x0436 + [char]0x0435 + '?')
$missedOpportunity = Text-FromBase64 '0KPQv9GD0YnQtdC90L3QsNGPINCy0L7Qt9C80L7QttC90L7RgdGC0Yw='
$pilotBaselineMetrics = Text-FromBase64 '0J/QuNC70L7RgiAvIGJhc2VsaW5lIG1ldHJpY3M='
$recoverySafeWording = Text-FromBase64 'QUkgUmVjb3Zlcnk6INCz0LjQv9C+0YLQtdC30LA7INC00L7QutCw0LfQsNGC0LXQu9GM0YHRgtCy0LAg0LLQvtGB0YHRgtCw0L3QvtCy0LvQtdC90LjRjyDQsdGA0L7QvdC40YDQvtCy0LDQvdC40Lkg0L/QvtC60LAgcGVuZGluZw=='
$nextArtifactCombo = Text-FromBase64 '0KHQu9C10LTRg9GO0YnQuNC5INCw0YDRgtC10YTQsNC60YIgLyDQodC70LXQtNGD0Y7RidC40Lkg0L/RgNC+0LLQtdGA0L7Rh9C90YvQuSDQsNGA0YLQtdGE0LDQutGC'
$evidenceGapAnchor = Text-FromBase64 'RXZpZGVuY2UgZ2FwOiDQvdC10YIgZXZpZGVuY2Ug0L/QviBQTUYvUENGL2N1c3RvbWVyIHN1Y2Nlc3MvYnVzaW5lc3MgaW1wYWN0'
$fixedRefusalCannot = Text-FromBase64 '0J3QtdC70YzQt9GPINGD0YLQstC10YDQttC00LDRgtGMOiBQTUYvUENGL9Cx0LjQt9C90LXRgS3RjdGE0YTQtdC60YIg0LHQtdC3IGV2aWRlbmNlIHJlZnMu'
$fixedRefusalStep = Text-FromBase64 '0KHQu9C10LTRg9GO0YnQuNC5INGI0LDQszog0YHQvtCx0YDQsNGC0YwgcmV0ZW50aW9uLCB3aWxsaW5nbmVzcy10by1wYXkg0LggYnVzaW5lc3MtaW1wYWN0IGV2aWRlbmNlLg=='
$noOptionalFollowUp = Text-FromBase64 '0L3QtSDQtNC+0LHQsNCy0LvRj9C5IG9wdGlvbmFsIGZvbGxvdy11cA=='

$goalFiles = @(
  'AGENTS.md',
  'practices/copilot-ux/dialogue-first.md',
  'practices/copilot-ux/goal-led-validation.md',
  'workflows/reviews/evidence-gap-review.md',
  'workflows/activation/activate-cpo-copilot.md'
)

foreach ($path in $goalFiles) {
  $text = Read-RepoText $path
  Assert-Contains -Name $path -Text $text -Needle $goalCard
  Assert-Contains -Name $path -Text $text -Needle $sourceRouting
  Assert-Contains -Name $path -Text $text -Needle $evidenceCheck
  Assert-Contains -Name $path -Text $text -Needle $nextArtifact
  Assert-Contains -Name $path -Text $text -Needle $nextArtifactCombo
  Assert-Contains -Name $path -Text $text -Needle $decisionAfter
  Assert-Contains -Name $path -Text $text -Needle $defaultBriefness
  Assert-Contains -Name $path -Text $text -Needle $maxThreeQuestions
}

$dialogue = Read-RepoText 'practices/copilot-ux/dialogue-first.md'
Assert-Contains -Name 'practices/copilot-ux/dialogue-first.md' -Text $dialogue -Needle $firstStep
Assert-Contains -Name 'practices/copilot-ux/dialogue-first.md' -Text $dialogue -Needle $clientFeedback
Assert-Contains -Name 'practices/copilot-ux/dialogue-first.md' -Text $dialogue -Needle $feedbackDecision
Assert-Contains -Name 'practices/copilot-ux/dialogue-first.md' -Text $dialogue -Needle $fullScenarioFrame
Assert-Contains -Name 'practices/copilot-ux/dialogue-first.md' -Text $dialogue -Needle $recoverySafeWording
Assert-Contains -Name 'practices/copilot-ux/dialogue-first.md' -Text $dialogue -Needle $missedOpportunity
Assert-Contains -Name 'practices/copilot-ux/dialogue-first.md' -Text $dialogue -Needle $pilotBaselineMetrics

$artifactBoundaries = Read-RepoText 'practices/copilot-ux/artifact-boundaries.md'
Assert-Contains -Name 'practices/copilot-ux/artifact-boundaries.md' -Text $artifactBoundaries -Needle 'UI-evidence gate'
Assert-Contains -Name 'practices/copilot-ux/artifact-boundaries.md' -Text $artifactBoundaries -Needle $uiNotChecked
Assert-Contains -Name 'practices/copilot-ux/artifact-boundaries.md' -Text $artifactBoundaries -Needle $notReadyHandoff

$goalLed = Read-RepoText 'practices/copilot-ux/goal-led-validation.md'
Assert-Contains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle $visiblePafCheck
Assert-Contains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle 'PAF:'
Assert-Contains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle $evidenceLevel
Assert-Contains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle $canTake
Assert-Contains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle $willCheck
Assert-Contains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle $nextArtifactShort
Assert-Contains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle $decisionAfter
Assert-NotContains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle 'PAF status:'
Assert-NotContains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle '- Applied/not applied:'
Assert-NotContains -Name 'practices/copilot-ux/goal-led-validation.md' -Text $goalLed -Needle '- Evidence level:'

$evidenceReview = Read-RepoText 'workflows/reviews/evidence-gap-review.md'
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $evidenceGapAnchor
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $fixedRefusalCannot
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $fixedRefusalStep
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $noOptionalFollowUp
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $attribution
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $channel
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $moment
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $handoff
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $recoverySafeWording
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $missedOpportunity
Assert-Contains -Name 'workflows/reviews/evidence-gap-review.md' -Text $evidenceReview -Needle $pilotBaselineMetrics

$pafConsistency = Read-RepoText 'workflows/reviews/paf-consistency-review.md'
Assert-Contains -Name 'workflows/reviews/paf-consistency-review.md' -Text $pafConsistency -Needle $visiblePafCheck
Assert-Contains -Name 'workflows/reviews/paf-consistency-review.md' -Text $pafConsistency -Needle $evidenceLevel
Assert-Contains -Name 'workflows/reviews/paf-consistency-review.md' -Text $pafConsistency -Needle $nextArtifactShort
Assert-Contains -Name 'workflows/reviews/paf-consistency-review.md' -Text $pafConsistency -Needle $evidenceRu
Assert-Contains -Name 'workflows/reviews/paf-consistency-review.md' -Text $pafConsistency -Needle $missingRu
Assert-Contains -Name 'workflows/reviews/paf-consistency-review.md' -Text $pafConsistency -Needle $cannotClaimRu
Assert-Contains -Name 'workflows/reviews/paf-consistency-review.md' -Text $pafConsistency -Needle $nextStepRu

$agents = Read-RepoText 'AGENTS.md'
Assert-Contains -Name 'AGENTS.md' -Text $agents -Needle $evidenceGapAnchor
Assert-Contains -Name 'AGENTS.md' -Text $agents -Needle $fixedRefusalCannot
Assert-Contains -Name 'AGENTS.md' -Text $agents -Needle $fixedRefusalStep

$pafEvidence = Read-RepoText 'practices/paf/evidence-and-uncertainty.md'
Assert-Contains -Name 'practices/paf/evidence-and-uncertainty.md' -Text $pafEvidence -Needle $evidenceGapAnchor
Assert-Contains -Name 'practices/paf/evidence-and-uncertainty.md' -Text $pafEvidence -Needle $fixedRefusalCannot
Assert-Contains -Name 'practices/paf/evidence-and-uncertainty.md' -Text $pafEvidence -Needle $fixedRefusalStep
Assert-Contains -Name 'practices/paf/evidence-and-uncertainty.md' -Text $pafEvidence -Needle $noOptionalFollowUp

$activationWorkflow = Read-RepoText 'workflows/activation/activate-cpo-copilot.md'
Assert-Contains -Name 'workflows/activation/activate-cpo-copilot.md' -Text $activationWorkflow -Needle $whatIsCloser

$clientFeedbackEval = Read-RepoText 'evals/behavior/client-feedback-intake-case.yaml'
Assert-Contains -Name 'evals/behavior/client-feedback-intake-case.yaml' -Text $clientFeedbackEval -Needle $clientFeedback
Assert-Contains -Name 'evals/behavior/client-feedback-intake-case.yaml' -Text $clientFeedbackEval -Needle $maxThreeQuestions
Assert-Contains -Name 'evals/behavior/client-feedback-intake-case.yaml' -Text $clientFeedbackEval -Needle $noLongPafGoalTemplate

$uiEvidenceEval = Read-RepoText 'evals/behavior/ui-evidence-gate-case.yaml'
Assert-Contains -Name 'evals/behavior/ui-evidence-gate-case.yaml' -Text $uiEvidenceEval -Needle $currentUi
Assert-Contains -Name 'evals/behavior/ui-evidence-gate-case.yaml' -Text $uiEvidenceEval -Needle $notReadyHandoff
Assert-Contains -Name 'evals/behavior/ui-evidence-gate-case.yaml' -Text $uiEvidenceEval -Needle 'UI-evidence gate'

$rubric = Read-RepoText 'evals/rubrics/product-ux-rubric.md'
Assert-Contains -Name 'evals/rubrics/product-ux-rubric.md' -Text $rubric -Needle $russianUserFacing
Assert-Contains -Name 'evals/rubrics/product-ux-rubric.md' -Text $rubric -Needle $briefness
Assert-Contains -Name 'evals/rubrics/product-ux-rubric.md' -Text $rubric -Needle $anglicisms

Write-Host "check-product-ux-regressions: ok"
