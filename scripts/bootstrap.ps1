[CmdletBinding()]
param(
    [string]$SkillsRoot = (Join-Path $env:USERPROFILE '.agents\skills'),
    [switch]$InitializeUpstreams,
    [switch]$Register,
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

$definitions = @(
    [ordered]@{
        Name = 'math-modeling-skill'
        RelativePath = 'upstream-skills\math-modeling-skill'
    },
    [ordered]@{
        Name = 'math-modeling-solver'
        RelativePath = 'upstream-skills\math-modeling-skills\skills\math-modeling-solver'
    },
    [ordered]@{
        Name = 'math-modeling-paper'
        RelativePath = 'upstream-skills\math-modeling-skills\skills\math-modeling-paper'
    }
)

function Get-NormalizedPath([string]$Path) {
    return ([System.IO.Path]::GetFullPath($Path)).TrimEnd('\')
}

function Get-SkillName([string]$SkillPath) {
    $skillFile = Join-Path $SkillPath 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile)) {
        return $null
    }
    $match = Select-String -LiteralPath $skillFile -Pattern '^name:\s*(.+?)\s*$' | Select-Object -First 1
    if (-not $match) {
        return $null
    }
    return $match.Matches[0].Groups[1].Value.Trim()
}

function Initialize-Upstreams {
    $output = @(& git -C $ProjectRoot submodule update --init --recursive 2>&1)
    if ($LASTEXITCODE -ne 0) {
        throw ("Git submodule initialization failed:{0}{1}" -f [Environment]::NewLine, ($output -join [Environment]::NewLine))
    }
}

function Resolve-SkillSource([hashtable]$Definition) {
    $source = Join-Path $ProjectRoot $Definition.RelativePath
    if (-not (Test-Path -LiteralPath $source)) {
        throw "Missing bundled Skill source for $($Definition.Name): $source. Run with -InitializeUpstreams."
    }
    if ((Get-SkillName $source) -ne $Definition.Name) {
        throw "Bundled Skill name mismatch for $($Definition.Name): $source"
    }
    return (Get-NormalizedPath $source)
}

function Test-ExpectedJunction([System.IO.FileSystemInfo]$Item, [string]$ExpectedTarget) {
    if ($null -eq $Item -or $Item.LinkType -ne 'Junction') {
        return $false
    }
    $target = @($Item.Target) | Select-Object -First 1
    if ([string]::IsNullOrWhiteSpace([string]$target)) {
        return $false
    }
    return (Get-NormalizedPath ([string]$target)) -eq (Get-NormalizedPath $ExpectedTarget)
}

function Get-DiscoveryState([string]$Destination, [string]$Source) {
    $item = Get-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
    if ($null -eq $item) {
        return [ordered]@{ State = 'MISSING'; Item = $null }
    }
    if (Test-ExpectedJunction $item $Source) {
        return [ordered]@{ State = 'READY'; Item = $item }
    }
    return [ordered]@{ State = 'CONFLICT'; Item = $item }
}

try {
    if ($InitializeUpstreams) {
        Initialize-Upstreams
    }

    $resolved = @()
    foreach ($definition in $definitions) {
        $resolved += [pscustomobject]@{
            Definition = $definition
            Source = Resolve-SkillSource $definition
            Destination = Join-Path $SkillsRoot $definition.Name
        }
    }

    $states = @()
    foreach ($entry in $resolved) {
        $state = Get-DiscoveryState $entry.Destination $entry.Source
        $states += [pscustomobject]@{
            Name = $entry.Definition.Name
            Source = $entry.Source
            Destination = $entry.Destination
            State = $state.State
        }
    }

    $conflicts = @($states | Where-Object { $_.State -eq 'CONFLICT' })
    if ($Register -and $conflicts.Count -eq 0) {
        New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
        foreach ($entry in $states | Where-Object { $_.State -eq 'MISSING' }) {
            $parent = Split-Path -Parent $entry.Destination
            New-Item -ItemType Directory -Force -Path $parent | Out-Null
            New-Item -ItemType Junction -Path $entry.Destination -Target $entry.Source | Out-Null
        }
        $states = @()
        foreach ($entry in $resolved) {
            $state = Get-DiscoveryState $entry.Destination $entry.Source
            $states += [pscustomobject]@{
                Name = $entry.Definition.Name
                Source = $entry.Source
                Destination = $entry.Destination
                State = $state.State
            }
        }
    }

    $failed = @()
    foreach ($entry in $states) {
        if ($entry.State -eq 'READY') {
            Write-Output ("READY {0} (path: {1}; source: {2})" -f $entry.Name, $entry.Destination, $entry.Source)
        }
        elseif ($entry.State -eq 'MISSING') {
            Write-Output ("MISSING {0} (expected link: {1})" -f $entry.Name, $entry.Destination)
            $failed += $entry.Name
        }
        else {
            Write-Output ("CONFLICT {0} (path: {1}; expected source: {2})" -f $entry.Name, $entry.Destination, $entry.Source)
            $failed += $entry.Name
        }
    }

    if ($failed.Count -gt 0) {
        if ($conflicts.Count -gt 0) {
            throw 'Bootstrap stopped without replacing conflicting discovery entries.'
        }
        throw 'Run with -Register to create missing discovery junctions.'
    }

    Write-Output '3/3 READY'
}
catch {
    throw $_.Exception.Message
}

