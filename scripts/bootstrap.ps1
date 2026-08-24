[CmdletBinding()]
param(
    [string]$SkillsRoot = (Join-Path $env:USERPROFILE '.agents\skills'),
    [switch]$InitializeUpstreams,
    [switch]$Register,
    [switch]$InstallCopy,
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

function Test-ExpectedPhysicalCopy([System.IO.FileSystemInfo]$Item, [string]$ExpectedName) {
    if ($null -eq $Item -or $Item.LinkType) {
        return $false
    }
    return (Get-SkillName $Item.FullName) -eq $ExpectedName
}

function Get-DiscoveryState([string]$Destination, [string]$Source, [string]$Name) {
    $item = Get-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
    if ($null -eq $item) {
        return [ordered]@{ State = 'MISSING'; Item = $null }
    }
    if ((Test-ExpectedJunction $item $Source) -or (Test-ExpectedPhysicalCopy $item $Name)) {
        return [ordered]@{ State = 'READY'; Item = $item }
    }
    return [ordered]@{ State = 'CONFLICT'; Item = $item }
}

function Assert-SafeDestination([string]$Destination) {
    $root = Get-NormalizedPath $SkillsRoot
    $full = Get-NormalizedPath $Destination
    if (-not $full.StartsWith($root + '\', [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing out-of-scope Skill destination: $full"
    }
}

function Install-SkillCopy([string]$Source, [string]$Destination) {
    Assert-SafeDestination $Destination
    $existing = Get-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
    if ($null -ne $existing) {
        Remove-Item -LiteralPath $Destination -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    Get-ChildItem -LiteralPath $Source -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $Destination -Recurse -Force
    }
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

    if ($InstallCopy) {
        New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
        foreach ($entry in $resolved) {
            Install-SkillCopy $entry.Source $entry.Destination
        }
    }
    elseif ($Register) {
        New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
        foreach ($entry in $resolved) {
            $existing = Get-Item -LiteralPath $entry.Destination -Force -ErrorAction SilentlyContinue
            if ($null -eq $existing) {
                New-Item -ItemType Junction -Path $entry.Destination -Target $entry.Source | Out-Null
            }
        }
    }

    $states = @()
    foreach ($entry in $resolved) {
        $state = Get-DiscoveryState $entry.Destination $entry.Source $entry.Definition.Name
        $states += [pscustomobject]@{
            Name = $entry.Definition.Name
            Source = $entry.Source
            Destination = $entry.Destination
            State = $state.State
        }
    }

    $failed = @()
    foreach ($entry in $states) {
        if ($entry.State -eq 'READY') {
            Write-Output ("READY {0} (path: {1}; source: {2})" -f $entry.Name, $entry.Destination, $entry.Source)
        }
        elseif ($entry.State -eq 'MISSING') {
            Write-Output ("MISSING {0} (expected global path: {1})" -f $entry.Name, $entry.Destination)
            $failed += $entry.Name
        }
        else {
            Write-Output ("CONFLICT {0} (path: {1}; expected source: {2})" -f $entry.Name, $entry.Destination, $entry.Source)
            $failed += $entry.Name
        }
    }

    if ($failed.Count -gt 0) {
        if ($InstallCopy) {
            throw 'Global copy installation did not produce valid physical Skill directories.'
        }
        if ($Register) {
            throw 'Global junction registration encountered a conflicting deployment.'
        }
        throw 'Run with -InstallCopy to install full Skills globally.'
    }

    Write-Output '3/3 READY'
}
catch {
    throw $_.Exception.Message
}
