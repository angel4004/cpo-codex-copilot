$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$registry = Get-Content -Raw -Path (Join-Path $RepoRoot 'workflow-registry.yaml')
$workflowIds = [regex]::Matches($registry, '(?m)^\s*-\s+workflow_id:\s*(\S+)') | ForEach-Object { $_.Groups[1].Value.Trim() }
$required = @(
  'case_id',
  'description_ru',
  'user_task_type',
  'required_workflow',
  'prompt_ru',
  'expected_behavior_ru',
  'forbidden_claims',
  'expected_artifacts',
  'rubric'
)

function Fail($Message) {
  Write-Error $Message
  exit 1
}

$files = @()
$files += Get-ChildItem -Path (Join-Path $RepoRoot 'evals/behavior') -Filter '*.yaml' -File
$files += Get-ChildItem -Path (Join-Path $RepoRoot 'evals/protocol') -Filter '*.yaml' -File

foreach ($file in $files) {
  $text = Get-Content -Raw -Path $file.FullName
  foreach ($field in $required) {
    if ($text -notmatch "(?m)^${field}:") {
      Fail "eval_case_missing_field: $($file.Name) field=$field"
    }
  }
  $workflow = ([regex]::Match($text, '(?m)^required_workflow:\s*(\S+)')).Groups[1].Value.Trim()
  if ($workflowIds -notcontains $workflow) {
    Fail "eval_case_unknown_workflow: $($file.Name) workflow=$workflow"
  }
  $rubric = ([regex]::Match($text, '(?m)^rubric:\s*(.+)$')).Groups[1].Value.Trim()
  if (-not (Test-Path -Path (Join-Path $RepoRoot $rubric))) {
    Fail "eval_case_missing_rubric: $($file.Name) rubric=$rubric"
  }
}

Write-Host 'check-eval-schema: ok'
