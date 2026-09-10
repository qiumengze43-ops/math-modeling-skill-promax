$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$routerPath = Join-Path $projectRoot 'skills\math-modeling-promax\SKILL.md'
$bootstrapPath = Join-Path $projectRoot 'scripts\bootstrap.ps1'
$utf8 = New-Object System.Text.UTF8Encoding($false, $true)

if (-not (Test-Path -LiteralPath $routerPath -PathType Leaf)) {
    throw "Global router Skill is missing: $routerPath"
}

$content = [IO.File]::ReadAllText($routerPath, $utf8)
$requiredChinese = -join ([char[]](0x5bf9,0x4e8e,0x6570,0x5b66,0x5efa,0x6a21,0x4efb,0x52a1))
$requiredRule = -join ([char[]](0x4e0d,0x5f97,0x7ed5,0x8fc7,0x8def,0x7531,0x5668,0x76f4,0x63a5,0x8c03,0x7528,0x4e0b,0x5c42)) + ' Skill'
foreach ($required in @(
    'name: math-modeling-promax',
    'math-modeling-skill',
    'math-modeling-solver',
    'math-modeling-paper',
    'ROUTE_REQUIRED',
    'NO_DIRECT_DOWNSTREAM_CALLS',
    'Run Ledger',
    'Claim Ledger',
    'Figure Contract',
    'Delivery Manifest',
    $requiredChinese,
    $requiredRule
)) {
    if ($content -notlike "*$required*") {
        throw "Global router is missing required contract text: $required"
    }
}

$bootstrap = [IO.File]::ReadAllText($bootstrapPath, $utf8)
if ($bootstrap -notlike '*math-modeling-promax*') {
    throw 'Bootstrap does not install the global Promax router Skill.'
}

if ($bootstrap -notlike '*Use only when routed by math-modeling-promax*') {
    throw 'Bootstrap does not apply the mandatory child Skill routing description overlay.'
}

Write-Output 'GLOBAL_ROUTER_CHECK_PASS'
