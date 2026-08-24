$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$bootstrap = Join-Path $projectRoot 'scripts\bootstrap.ps1'
$fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('promax-bootstrap-fixture-' + [guid]::NewGuid().ToString('N'))
$skillsRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('promax-bootstrap-skills-' + [guid]::NewGuid().ToString('N'))

$definitions = @(
    @{ Name = 'math-modeling-promax'; RelativePath = 'skills\math-modeling-promax' },
    @{ Name = 'math-modeling-skill'; RelativePath = 'upstream-skills\math-modeling-skill' },
    @{ Name = 'math-modeling-solver'; RelativePath = 'upstream-skills\math-modeling-skills\skills\math-modeling-solver' },
    @{ Name = 'math-modeling-paper'; RelativePath = 'upstream-skills\math-modeling-skills\skills\math-modeling-paper' }
)

function Invoke-Bootstrap([string]$SourceRoot, [string]$DiscoveryRoot, [bool]$DoRegister) {
    try {
        if ($DoRegister) {
            $output = @(& $bootstrap -ProjectRoot $SourceRoot -SkillsRoot $DiscoveryRoot -Register 2>&1)
        }
        else {
            $output = @(& $bootstrap -ProjectRoot $SourceRoot -SkillsRoot $DiscoveryRoot 2>&1)
        }
    }
    catch {
        $output = @($_)
    }
    $joined = $output -join [Environment]::NewLine
    $exitCode = if ($joined -match '4/4 READY') { 0 } else { 1 }
    [pscustomobject]@{
        Output = $joined
        ExitCode = $exitCode
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

    $readOnly = Invoke-Bootstrap $fixtureRoot $skillsRoot $false
    if ($readOnly.ExitCode -eq 0) {
        throw "Read-only bootstrap unexpectedly passed: $($readOnly.Output)"
    }

    $registered = Invoke-Bootstrap $fixtureRoot $skillsRoot $true
    if ($registered.ExitCode -ne 0 -or $registered.Output -notmatch '4/4 READY') {
        throw "Bootstrap registration failed: $($registered.Output)"
    }

    foreach ($definition in $definitions) {
        $destination = Join-Path $skillsRoot $definition.Name
        $item = Get-Item -LiteralPath $destination -Force
        if ($item.LinkType -ne 'Junction') {
            throw "Expected junction at $destination, got LinkType '$($item.LinkType)'"
        }
    }

    $second = Invoke-Bootstrap $fixtureRoot $skillsRoot $true
    if ($second.ExitCode -ne 0 -or $second.Output -notmatch '4/4 READY') {
        throw "Repeated registration was not idempotent: $($second.Output)"
    }

    $conflictRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('promax-bootstrap-conflict-' + [guid]::NewGuid().ToString('N'))
    try {
        New-Item -ItemType Directory -Force -Path $conflictRoot | Out-Null
        $conflictPath = Join-Path $conflictRoot 'math-modeling-skill'
        New-Item -ItemType Directory -Force -Path $conflictPath | Out-Null
        $marker = Join-Path $conflictPath 'keep.txt'
        Set-Content -LiteralPath $marker -Value 'preserve'
        $conflict = Invoke-Bootstrap $fixtureRoot $conflictRoot $true
        if ($conflict.ExitCode -eq 0 -or $conflict.Output -notmatch 'CONFLICT') {
            throw "Bootstrap unexpectedly replaced or accepted a conflicting directory: $($conflict.Output)"
        }
        if (-not (Test-Path -LiteralPath $marker)) {
            throw 'Conflicting directory was modified'
        }
    }
    finally {
        if (Test-Path -LiteralPath $conflictRoot) { Remove-Item -LiteralPath $conflictRoot -Recurse -Force }
    }
}
finally {
    if (Test-Path -LiteralPath $fixtureRoot) { Remove-Item -LiteralPath $fixtureRoot -Recurse -Force }
    if (Test-Path -LiteralPath $skillsRoot) { Remove-Item -LiteralPath $skillsRoot -Recurse -Force }
}

Write-Output 'BOOTSTRAP_BUNDLE_CHECK_PASS'
