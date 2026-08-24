$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$files = @(
    (Join-Path $projectRoot 'README.md'),
    (Join-Path $projectRoot 'docs\bootstrap.md')
)
$required = @('upstream-skills', '-InstallCopy', '-InitializeUpstreams', 'physical', 'routed')

foreach ($file in $files) {
    $text = Get-Content -Raw -LiteralPath $file
    foreach ($term in $required) {
        if ($text -notmatch [regex]::Escape($term)) {
            throw "Documentation missing '$term': $file"
        }
    }
}

Write-Output 'BUNDLE_DOCS_CHECK_PASS'
