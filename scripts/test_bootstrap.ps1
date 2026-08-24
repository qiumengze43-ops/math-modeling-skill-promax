$ErrorActionPreference = 'Stop'
$skillsRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('bootstrap-test-' + [guid]::NewGuid().ToString('N'))
try {
    New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
    try {
        & (Join-Path $PSScriptRoot 'bootstrap.ps1') -SkillsRoot $skillsRoot
        throw 'Bootstrap unexpectedly passed with an empty global Skill root'
    }
    catch {
        if ($_.Exception.Message -notmatch 'Run with -InstallCopy') { throw }
    }
}
finally {
    if (Test-Path -LiteralPath $skillsRoot) { Remove-Item -LiteralPath $skillsRoot -Recurse -Force }
}
Write-Output 'BOOTSTRAP_MISSING_CHECK_PASS'
