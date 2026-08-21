$ErrorActionPreference = 'Stop'
$skillsRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('bootstrap-install-test-' + [guid]::NewGuid().ToString('N'))
$bootstrap = Join-Path $PSScriptRoot 'bootstrap.ps1'
$expected = @{
    'math-modeling-skill' = 'math-modeling-skill'
    'math-modeling-solver' = 'math-modeling-solver'
    'math-modeling-paper' = 'math-modeling-paper'
}
try {
    New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
    $output = @(& $bootstrap -SkillsRoot $skillsRoot -InstallMissing 2>&1)
    if ($LASTEXITCODE -ne 0) {
        throw "Bootstrap install failed with exit code $LASTEXITCODE`n$($output -join "`n")"
    }
    $joined = $output -join "`n"
    if ($joined -notmatch '3/3 READY') {
        throw "Bootstrap install did not report 3/3 READY`n$joined"
    }
    foreach ($directory in $expected.Keys) {
        $skillFile = Join-Path (Join-Path $skillsRoot $directory) 'SKILL.md'
        if (-not (Test-Path -LiteralPath $skillFile)) {
            throw "Missing installed SKILL.md: $skillFile"
        }
        $nameMatch = Select-String -LiteralPath $skillFile -Pattern '^name:\s*(.+?)\s*$' | Select-Object -First 1
        if (-not $nameMatch -or $nameMatch.Matches[0].Groups[1].Value.Trim() -ne $expected[$directory]) {
            throw "Installed Skill name mismatch: $skillFile"
        }
    }
}
finally {
    if (Test-Path -LiteralPath $skillsRoot) {
        Remove-Item -LiteralPath $skillsRoot -Recurse -Force
    }
}
Write-Output 'BOOTSTRAP_INSTALL_CHECK_PASS'