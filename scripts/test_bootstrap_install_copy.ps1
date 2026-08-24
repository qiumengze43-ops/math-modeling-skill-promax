$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$bootstrap = Join-Path $projectRoot 'scripts\bootstrap.ps1'
$fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('promax-copy-fixture-' + [guid]::NewGuid().ToString('N'))
$skillsRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('promax-copy-skills-' + [guid]::NewGuid().ToString('N'))

$definitions = @(
    @{ Name = 'math-modeling-promax'; RelativePath = 'skills\math-modeling-promax' },
    @{ Name = 'math-modeling-skill'; RelativePath = 'upstream-skills\math-modeling-skill' },
    @{ Name = 'math-modeling-solver'; RelativePath = 'upstream-skills\math-modeling-skills\skills\math-modeling-solver' },
    @{ Name = 'math-modeling-paper'; RelativePath = 'upstream-skills\math-modeling-skills\skills\math-modeling-paper' }
)

function Invoke-CopyInstall {
    try {
        $output = @(& $bootstrap -ProjectRoot $fixtureRoot -SkillsRoot $skillsRoot -InstallCopy 2>&1)
    }
    catch {
        $output = @($_)
    }
    [pscustomobject]@{
        Output = $output -join [Environment]::NewLine
        Passed = (($output -join [Environment]::NewLine) -match '4/4 READY')
    }
}

try {
    foreach ($definition in $definitions) {
        $skillDirectory = Join-Path $fixtureRoot $definition.RelativePath
        New-Item -ItemType Directory -Force -Path $skillDirectory | Out-Null
        Set-Content -LiteralPath (Join-Path $skillDirectory 'SKILL.md') -Encoding UTF8 -Value @"
---
name: $($definition.Name)
description: fixture
---

# Fixture
"@
    }
    New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null

    $first = Invoke-CopyInstall
    if (-not $first.Passed) {
        throw "Copy installation failed before implementation: $($first.Output)"
    }

    foreach ($definition in $definitions) {
        $destination = Join-Path $skillsRoot $definition.Name
        $item = Get-Item -LiteralPath $destination -Force
        if ($item.LinkType) {
            throw "Expected a physical Skill directory, got LinkType '$($item.LinkType)': $destination"
        }
        if (-not (Test-Path -LiteralPath (Join-Path $destination 'SKILL.md'))) {
            throw "Missing copied SKILL.md: $destination"
        }
        if ($definition.Name -ne 'math-modeling-promax') {
            $description = [IO.File]::ReadAllText((Join-Path $destination 'SKILL.md'), (New-Object System.Text.UTF8Encoding($false, $true)))
            if ($description -notmatch '(?m)^description:.*math-modeling-promax.*') {
                throw "Copied child Skill description is missing mandatory router prefix: $destination"
            }
        }
    }

    $marker = Join-Path (Join-Path $skillsRoot 'math-modeling-skill') 'stale.txt'
    Set-Content -LiteralPath $marker -Value 'old deployment'
    $second = Invoke-CopyInstall
    if (-not $second.Passed) {
        throw "Repeated copy installation failed: $($second.Output)"
    }
    if (Test-Path -LiteralPath $marker) {
        throw 'Copy installation left stale files in a replaced Skill directory'
    }
}
finally {
    if (Test-Path -LiteralPath $fixtureRoot) { Remove-Item -LiteralPath $fixtureRoot -Recurse -Force }
    if (Test-Path -LiteralPath $skillsRoot) { Remove-Item -LiteralPath $skillsRoot -Recurse -Force }
}

Write-Output 'BOOTSTRAP_COPY_CHECK_PASS'
