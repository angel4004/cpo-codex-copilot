param(
  [string] $MatrixPath = "",
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
if (-not $MatrixPath) {
  $MatrixPath = Join-Path $RepoRoot 'paf-enforcement-matrix.yaml'
}

function Add-Error {
  param([Parameter(Mandatory=$true)][string]$Message)
  $script:Errors += $Message
}

function Get-InlineList {
  param(
    [Parameter(Mandatory=$true)][string]$Body,
    [Parameter(Mandatory=$true)][string]$Field
  )
  $match = [regex]::Match($Body, "(?m)^\s+${Field}:\s*\[(.*?)\]\s*$")
  if (-not $match.Success) { return @() }
  return @($match.Groups[1].Value -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

function Get-Scalar {
  param(
    [Parameter(Mandatory=$true)][string]$Body,
    [Parameter(Mandatory=$true)][string]$Field
  )
  $match = [regex]::Match($Body, "(?m)^\s+${Field}:\s*(.+?)\s*$")
  if (-not $match.Success) { return "" }
  return $match.Groups[1].Value.Trim()
}

function Get-RouteBlock {
  param(
    [Parameter(Mandatory=$true)][string]$Routing,
    [Parameter(Mandatory=$true)][string]$TaskType
  )
  $escaped = [regex]::Escape($TaskType)
  $match = [regex]::Match($Routing, "(?ms)^\s*-\s+task_type:\s*$escaped\s*(.*?)(?=^\s*-\s+task_type:|\z)")
  if ($match.Success) { return $match.Groups[1].Value }
  return ""
}

function Get-WorkflowBlock {
  param(
    [Parameter(Mandatory=$true)][string]$Registry,
    [Parameter(Mandatory=$true)][string]$WorkflowId
  )
  $escaped = [regex]::Escape($WorkflowId)
  $match = [regex]::Match($Registry, "(?ms)^\s*-\s+workflow_id:\s*$escaped\s*(.*?)(?=^\s*-\s+workflow_id:|\z)")
  if ($match.Success) { return $match.Groups[1].Value }
  return ""
}

$script:Errors = @()

if (-not (Test-Path -LiteralPath $MatrixPath)) {
  Add-Error "paf_enforcement_matrix_missing: $MatrixPath"
} else {
  $matrix = Get-Content -Raw -LiteralPath $MatrixPath -Encoding UTF8
}

$routingPath = Join-Path $RepoRoot 'ROUTING.yaml'
$registryPath = Join-Path $RepoRoot 'workflow-registry.yaml'
$manifestPath = Join-Path $RepoRoot 'memory/MANIFEST.yaml'
foreach ($path in @($routingPath, $registryPath, $manifestPath)) {
  if (-not (Test-Path -LiteralPath $path)) { Add-Error "paf_enforcement_required_file_missing: $path" }
}

if ($script:Errors.Count -eq 0) {
  $routing = Get-Content -Raw -LiteralPath $routingPath -Encoding UTF8
  $registry = Get-Content -Raw -LiteralPath $registryPath -Encoding UTF8
  $manifest = Get-Content -Raw -LiteralPath $manifestPath -Encoding UTF8
  $evidencePracticePath = Join-Path $RepoRoot 'practices/paf/evidence-and-uncertainty.md'
  if (-not (Test-Path -LiteralPath $evidencePracticePath)) {
    Add-Error "paf_enforcement_evidence_practice_missing: $evidencePracticePath"
  } else {
    $evidencePractice = Get-Content -Raw -LiteralPath $evidencePracticePath -Encoding UTF8
    foreach ($pattern in @('Refusal terminal rule', 'no optional polished-status follow-up', 'next evidence step', 'PMF/PCF/business impact: evidence pending')) {
      if ($evidencePractice -notmatch [regex]::Escape($pattern)) {
        Add-Error "paf_enforcement_forbidden_claim_refusal_guard_missing: $pattern"
      }
    }
  }

  foreach ($field in @('paf_enforcement','trusted_hooks','trace_coverage','methodology_context_loaded','decision_critical_paf_output_gated')) {
    if ($matrix -notmatch "(?m)^\s*-\s*$([regex]::Escape($field))\s*$") {
      Add-Error "paf_enforcement_report_field_missing: $field"
    }
  }

  foreach ($ruleType in @('prompt-level','workflow-level','gate-level','human-review-level')) {
    if ($matrix -notlike "*rule_type: $ruleType*") {
      Add-Error "paf_enforcement_rule_type_missing: $ruleType"
    }
  }

  $requiredClaimClasses = @(
    'paf_consistency_review',
    'pmf_claim_without_evidence',
    'pcf_claim_without_evidence',
    'business_impact_claim_without_evidence',
    'recommendation_under_weak_evidence',
    'contradictory_evidence',
    'missing_trace_required_checks',
    'missing_methodology_context'
  )
  foreach ($claimClass in $requiredClaimClasses) {
    if ($matrix -notlike "*claim_class: $claimClass*") {
      Add-Error "paf_enforcement_claim_class_missing: $claimClass"
    }
  }

  $rules = [regex]::Matches($matrix, '(?ms)^\s*-\s+rule_id:\s*([^\r\n]+)(.*?)(?=^\s*-\s+rule_id:|\z)')
  if ($rules.Count -eq 0) {
    Add-Error 'paf_enforcement_no_rules'
  }

  $negativeCoverage = @{}
  foreach ($rule in $rules) {
    $ruleId = $rule.Groups[1].Value.Trim()
    $body = $rule.Groups[2].Value
    $decisionCritical = Get-Scalar $body 'decision_critical'
    $claimClass = Get-Scalar $body 'claim_class'
    $ruleType = Get-Scalar $body 'rule_type'
    $route = Get-Scalar $body 'route'
    $workflow = Get-Scalar $body 'workflow'
    $sourceFiles = Get-InlineList $body 'source_files'
    $requiredMemory = Get-InlineList $body 'required_memory'
    $requiredPractices = Get-InlineList $body 'required_practices'
    $requiredChecks = Get-InlineList $body 'required_checks'
    $evals = Get-InlineList $body 'evals'
    $negativeEvals = Get-InlineList $body 'negative_evals'
    $reportFields = Get-InlineList $body 'report_fields'

    if ($decisionCritical -ne 'true') {
      Add-Error "paf_enforcement_rule_not_decision_critical: $ruleId"
    }
    if (@('prompt-level','workflow-level','gate-level','human-review-level') -notcontains $ruleType) {
      Add-Error "paf_enforcement_unknown_rule_type: $ruleId rule_type=$ruleType"
    }
    if (-not $route) { Add-Error "paf_enforcement_rule_missing_route: $ruleId" }
    if (-not $workflow) { Add-Error "paf_enforcement_rule_missing_workflow: $ruleId" }
    if ($requiredMemory -notcontains 'methodology_context') {
      Add-Error "paf_enforcement_methodology_context_missing: $ruleId"
    }
    if ($requiredChecks -notcontains 'check-trace-coverage') {
      Add-Error "paf_enforcement_trace_check_missing: $ruleId"
    }
    if ($requiredChecks -notcontains 'check-paf-enforcement') {
      Add-Error "paf_enforcement_gate_missing: $ruleId"
    }
    if ($reportFields -notcontains 'paf_enforcement' -and $reportFields -notcontains 'trusted_hooks') {
      Add-Error "paf_enforcement_report_mapping_missing: $ruleId"
    }

    foreach ($rel in @($sourceFiles + $requiredPractices + $evals + $negativeEvals)) {
      if ($rel -and -not (Test-Path -LiteralPath (Join-Path $RepoRoot $rel))) {
        Add-Error "paf_enforcement_referenced_path_missing: $ruleId path=$rel"
      }
    }

    $workflowDocs = @($sourceFiles | Where-Object { $_ -like 'workflows/*' })
    if ($workflowDocs.Count -eq 0) {
      Add-Error "paf_enforcement_workflow_doc_missing: $ruleId"
    } else {
      $workflowText = (($workflowDocs | ForEach-Object {
        $docPath = Join-Path $RepoRoot $_
        if (Test-Path -LiteralPath $docPath) { Get-Content -Raw -LiteralPath $docPath -Encoding UTF8 } else { "" }
      }) -join "`n")
      if ($workflowText -notmatch 'evidence') {
        Add-Error "paf_enforcement_workflow_evidence_missing: $ruleId"
      }
      if ($workflowText -notmatch 'assumptions|допущ') {
        Add-Error "paf_enforcement_workflow_assumptions_missing: $ruleId"
      }
      if ($workflowText -notmatch 'forbidden claims|unsupported') {
        Add-Error "paf_enforcement_workflow_forbidden_claims_missing: $ruleId"
      }
    }

    foreach ($evalPath in $negativeEvals) {
      if ($evalPath) {
        $fullPath = Join-Path $RepoRoot $evalPath
        if (Test-Path -LiteralPath $fullPath) {
          $evalText = Get-Content -Raw -LiteralPath $fullPath -Encoding UTF8
          if ($evalText -notmatch '(?m)^negative_eval:\s*true\s*$') {
            Add-Error "paf_enforcement_negative_eval_not_marked: $ruleId eval=$evalPath"
          }
          if ($claimClass -and $evalText -notlike "*claim_class: $claimClass*") {
            Add-Error "paf_enforcement_negative_eval_claim_mismatch: $ruleId eval=$evalPath claim=$claimClass"
          }
          $negativeCoverage[$claimClass] = $true
        }
      }
    }

    $routeBlock = Get-RouteBlock $routing $route
    if (-not $routeBlock) {
      Add-Error "paf_enforcement_route_missing: $ruleId route=$route"
    } else {
      $routeWorkflow = Get-Scalar $routeBlock 'workflow'
      $routeMemory = Get-InlineList $routeBlock 'required_memory'
      $routeChecks = Get-InlineList $routeBlock 'required_checks'
      if ($routeWorkflow -ne $workflow) {
        Add-Error "paf_enforcement_route_workflow_mismatch: $ruleId route=$route workflow=$routeWorkflow expected=$workflow"
      }
      if ($routeMemory -notcontains 'methodology_context') {
        Add-Error "paf_enforcement_route_methodology_context_missing: $ruleId route=$route"
      }
      if ($routeChecks -notcontains 'check-trace-coverage') {
        Add-Error "paf_enforcement_route_trace_check_missing: $ruleId route=$route"
      }
      if ($routeChecks -notcontains 'check-paf-enforcement') {
        Add-Error "paf_enforcement_route_gate_missing: $ruleId route=$route"
      }
    }

    $workflowBlock = Get-WorkflowBlock $registry $workflow
    if (-not $workflowBlock) {
      Add-Error "paf_enforcement_workflow_missing: $ruleId workflow=$workflow"
    } else {
      $workflowChecks = Get-InlineList $workflowBlock 'required_checks'
      if ($workflowChecks -notcontains 'check-trace-coverage') {
        Add-Error "paf_enforcement_workflow_trace_check_missing: $ruleId workflow=$workflow"
      }
      if ($workflowChecks -notcontains 'check-paf-enforcement') {
        Add-Error "paf_enforcement_workflow_gate_missing: $ruleId workflow=$workflow"
      }
    }

    foreach ($mem in $requiredMemory) {
      if ($manifest -notmatch "(?m)^\s*-\s+memory_id:\s*$([regex]::Escape($mem))\s*$") {
        Add-Error "paf_enforcement_unknown_memory: $ruleId memory=$mem"
      }
    }
  }

  foreach ($claimClass in @(
    'pmf_claim_without_evidence',
    'pcf_claim_without_evidence',
    'business_impact_claim_without_evidence',
    'recommendation_under_weak_evidence',
    'contradictory_evidence',
    'missing_trace_required_checks',
    'missing_methodology_context'
  )) {
    if (-not $negativeCoverage.ContainsKey($claimClass)) {
      Add-Error "paf_enforcement_negative_eval_missing: $claimClass"
    }
  }
}

$hookReportPath = Join-Path $RepoRoot 'traces/reports/hook-self-test.json'
$trustedHooks = 'disabled_or_untrusted_hooks'
$traceEnforcementLevel = 'unverified_codex_runtime'
if (Test-Path -LiteralPath $hookReportPath) {
  try {
    $hookReport = Get-Content -Raw -LiteralPath $hookReportPath -Encoding UTF8 | ConvertFrom-Json
    $traceEnforcementLevel = if ($hookReport.trace_enforcement_level) { $hookReport.trace_enforcement_level } else { 'unverified_codex_runtime' }
    if ($hookReport.status -eq 'trusted_hooks' -and $hookReport.live_hook_verified -eq $true) {
      $trustedHooks = 'trusted_hooks'
    }
  } catch {
    $trustedHooks = 'disabled_or_untrusted_hooks'
    $traceEnforcementLevel = 'unverified_codex_runtime'
  }
}

$status = if ($script:Errors.Count -eq 0) { 'pass' } else { 'fail' }
$passEligible = $status -eq 'pass' -and $trustedHooks -eq 'trusted_hooks'
$result = [ordered]@{
  schema_version = 'paf-enforcement-proof-result-v0'
  status = $status
  pass_eligible = $passEligible
  paf_enforcement = if ($status -eq 'pass') { 'pass' } else { 'fail' }
  trusted_hooks = $trustedHooks
  trace_enforcement_level = $traceEnforcementLevel
  trace_coverage = if ($status -eq 'pass') { 'pass' } else { 'fail' }
  methodology_context_loaded = if ($status -eq 'pass') { 'pass' } else { 'fail' }
  decision_critical_paf_output_gated = if ($status -eq 'pass') { 'pass' } else { 'fail' }
  checked_at = (Get-Date).ToUniversalTime().ToString('o')
  matrix_path = 'paf-enforcement-matrix.yaml'
  errors = @($script:Errors)
}

if ($Json) {
  $result | ConvertTo-Json -Depth 10
} elseif ($status -eq 'pass') {
  Write-Host "check-paf-enforcement: ok"
  Write-Host "trusted_hooks: $trustedHooks"
  Write-Host "pass_eligible: $passEligible"
} else {
  foreach ($err in $script:Errors) { Write-Error $err }
}

if ($status -eq 'pass') { exit 0 }
exit 1
