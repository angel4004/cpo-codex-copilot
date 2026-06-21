param(
  [string[]] $SeedUrl = @(
    'https://productframework.ru/',
    'https://productframework.ru/library',
    'https://productframework.ru/ops/main'
  ),
  [string[]] $ExcludePath = @('/about','/privacy','/rss.xml','/client'),
  [string] $RegistryPath,
  [string] $OutputPath,
  [switch] $AllowNetwork
)

$ErrorActionPreference = 'Stop'

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillRoot = Split-Path -Parent $ScriptRoot
if (-not $RegistryPath) {
  $RegistryPath = Join-Path $SkillRoot 'sources/paf-source-registry.yaml'
}

function Get-RegistryUrls($Path) {
  if (-not (Test-Path -Path $Path)) { return @() }
  $text = Get-Content -Raw -Path $Path
  return [regex]::Matches($text, '(?m)^\s+(?:url|public_web_url):\s*(https?://\S+)\s*$') |
    ForEach-Object { $_.Groups[1].Value.Trim().TrimEnd('/') } |
    Sort-Object -Unique
}

function Normalize-Link($BaseUrl, $Href) {
  if (-not $Href) { return $null }
  if ($Href.StartsWith('#') -or $Href.StartsWith('mailto:') -or $Href.StartsWith('tel:')) { return $null }
  try {
    $uri = [System.Uri]::new([System.Uri]::new($BaseUrl), $Href)
  } catch {
    return $null
  }
  if ($uri.Host -ne 'productframework.ru') { return $null }
  if ($ExcludePath -contains $uri.AbsolutePath.TrimEnd('/')) { return $null }
  $builder = [System.UriBuilder]::new($uri)
  $builder.Scheme = 'https'
  $builder.Port = -1
  $builder.Query = ''
  $builder.Fragment = ''
  return $builder.Uri.AbsoluteUri.TrimEnd('/')
}

$registered = Get-RegistryUrls -Path $RegistryPath

if (-not $AllowNetwork) {
  $result = [ordered]@{
    mode = 'dry_run'
    allow_network = $false
    seed_urls = $SeedUrl
    registered_count = $registered.Count
    note = 'Run with -AllowNetwork to fetch pages and discover internal productframework.ru links.'
  }
  $json = $result | ConvertTo-Json -Depth 6
  if ($OutputPath) { $json | Set-Content -Path $OutputPath -Encoding UTF8 }
  Write-Output $json
  exit 0
}

$discovered = New-Object System.Collections.Generic.HashSet[string]
$errors = @()

foreach ($seed in $SeedUrl) {
  try {
    $response = Invoke-WebRequest -Uri $seed -UseBasicParsing -MaximumRedirection 5
    $html = [string]$response.Content
    $hrefMatches = [regex]::Matches($html, 'href\s*=\s*["'']([^"'']+)["'']', 'IgnoreCase')
    foreach ($match in $hrefMatches) {
      $normalized = Normalize-Link -BaseUrl $seed -Href $match.Groups[1].Value
      if ($normalized) { [void]$discovered.Add($normalized) }
    }
  } catch {
    $errors += [ordered]@{
      seed_url = $seed
      error = $_.Exception.Message
    }
  }
}

$missing = $discovered |
  Where-Object { $registered -notcontains $_ } |
  Sort-Object

$result = [ordered]@{
  mode = 'network_review'
  allow_network = $true
  checked_at_utc = [DateTime]::UtcNow.ToString('o')
  seed_urls = $SeedUrl
  registered_count = $registered.Count
  discovered_count = $discovered.Count
  missing_from_registry = @($missing)
  fetch_errors = @($errors)
}

$json = $result | ConvertTo-Json -Depth 8
if ($OutputPath) { $json | Set-Content -Path $OutputPath -Encoding UTF8 }
Write-Output $json
