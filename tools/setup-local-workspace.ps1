param(
  [switch]$SkipSmoke
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$LocalMemoryDir = Join-Path $RepoRoot 'memory\local'
$TemplateDir = Join-Path $RepoRoot 'memory\templates'

function Ensure-Directory($Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Copy-TemplateIfMissing($SourceName, $TargetName) {
  $source = Join-Path $TemplateDir $SourceName
  $target = Join-Path $LocalMemoryDir $TargetName

  if (-not (Test-Path -LiteralPath $source)) {
    throw "Missing template: $SourceName"
  }

  if (Test-Path -LiteralPath $target) {
    Write-Host "SKIP existing memory/local/$TargetName"
    return
  }

  Copy-Item -LiteralPath $source -Destination $target
  Write-Host "CREATE memory/local/$TargetName"
}

Ensure-Directory $LocalMemoryDir

Copy-TemplateIfMissing 'local-user-profile.template.md' 'user-profile.md'
Copy-TemplateIfMissing 'local-project-context.template.md' 'project-context.md'
Copy-TemplateIfMissing 'local-working-state.template.md' 'working-state.md'

Write-Host 'Local memory is git-ignored and was not overwritten.'

if (-not $SkipSmoke) {
  & (Join-Path $PSScriptRoot 'run-smoke.ps1')
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

Write-Host 'Next step: open this folder in Codex and use the activation phrase from README.md.'
