$ErrorActionPreference = 'Stop'
$bootstrap = Join-Path $PSScriptRoot 'bootstrap.ps1'
$text = [System.IO.File]::ReadAllText($bootstrap, [System.Text.Encoding]::UTF8)
if ($text -notmatch "\.agents\\skills") {
    throw 'Bootstrap default root must target .agents\\skills'
}
if ($text -match "SkillsRoot\s*=.*\.codex\\skills") {
    throw 'Bootstrap default root must not target .codex\\skills'
}
Write-Output 'BOOTSTRAP_DEFAULT_ROOT_CHECK_PASS'