$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$bootstrap = Join-Path $PSScriptRoot 'bootstrap.ps1'
$skillsRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('bootstrap-register-test-' + [guid]::NewGuid().ToString('N'))

try {
    New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
    $output = @(& $bootstrap -ProjectRoot $projectRoot -SkillsRoot $skillsRoot -Register 2>&1)
    $joined = $output -join [Environment]::NewLine
    if ($joined -notmatch '3/3 READY') {
        throw ("Bootstrap registration did not report 3/3 READY{0}{1}" -f [Environment]::NewLine, $joined)
    }
    foreach ($name in @('math-modeling-skill', 'math-modeling-solver', 'math-modeling-paper')) {
        $destination = Join-Path $skillsRoot $name
        $item = Get-Item -LiteralPath $destination -Force
        if ($item.LinkType -ne 'Junction') {
            throw "Registered Skill is not a junction: $destination"
        }
    }
}
finally {
    if (Test-Path -LiteralPath $skillsRoot) {
        Remove-Item -LiteralPath $skillsRoot -Recurse -Force
    }
}

Write-Output 'BOOTSTRAP_REGISTER_CHECK_PASS'
