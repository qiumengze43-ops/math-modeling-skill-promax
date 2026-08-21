[CmdletBinding()]
param(
    [string]$SkillsRoot = (Join-Path $env:USERPROFILE '.codex\skills'),
    [switch]$InstallMissing
)

$ErrorActionPreference = 'Stop'

$definitions = @(
    [ordered]@{ Name = 'math-modeling-skill'; PathCandidates = @('math-modeling-skill', 'math-modeling-skill-pro'); Repo = 'skillforCUMCM/math-modeling-skill-pro'; SourcePath = '.' },
    [ordered]@{ Name = 'math-modeling-solver'; PathCandidates = @('math-modeling-solver'); Repo = 'Lupynow/math-modeling-skills'; SourcePath = 'skills/math-modeling-solver' },
    [ordered]@{ Name = 'math-modeling-paper'; PathCandidates = @('math-modeling-paper'); Repo = 'Lupynow/math-modeling-skills'; SourcePath = 'skills/math-modeling-paper' }
)

function Get-SkillName([string]$skillPath) {
    $skillFile = Join-Path $skillPath 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile)) { return $null }
    $match = Select-String -LiteralPath $skillFile -Pattern '^name:\s*(.+?)\s*$' | Select-Object -First 1
    if (-not $match) { return $null }
    return $match.Matches[0].Groups[1].Value.Trim()
}

function Get-SkillPath([hashtable]$definition) {
    foreach ($candidate in $definition.PathCandidates) {
        $path = Join-Path $SkillsRoot $candidate
        if ((Get-SkillName $path) -eq $definition.Name) { return $path }
    }
    return $null
}

function Test-Skill([hashtable]$definition) {
    return $null -ne (Get-SkillPath $definition)
}

function Install-Skill([hashtable]$definition) {
    $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('math-modeling-bootstrap-' + [guid]::NewGuid().ToString('N'))
    $repoRoot = Join-Path $tempRoot 'repo'
    $destination = Join-Path $SkillsRoot $definition.Name
    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
    try {
        if (Test-Path -LiteralPath $destination) {
            throw "Destination already exists but failed validation: $destination"
        }
        New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
        git clone --depth 1 ("https://github.com/{0}.git" -f $definition.Repo) $repoRoot
        $source = if ($definition.SourcePath -eq '.') { $repoRoot } else { Join-Path $repoRoot $definition.SourcePath }
        if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {
            throw "SKILL.md not found at $source"
        }
        New-Item -ItemType Directory -Force -Path $destination | Out-Null
        Get-ChildItem -LiteralPath $source -Force | Where-Object { $_.Name -ne '.git' } | Copy-Item -Destination $destination -Recurse -Force
    }
    finally {
        if (Test-Path -LiteralPath $tempRoot) {
            Remove-Item -LiteralPath $tempRoot -Recurse -Force
        }
    }
}

$missing = @($definitions | Where-Object { -not (Test-Skill $_) })
if ($missing.Count -gt 0 -and -not $InstallMissing) {
    $missing | ForEach-Object { Write-Output ("MISSING {0} (source: {1})" -f $_.Name, $_.Repo) }
    Write-Error 'Run with -InstallMissing after confirming network and repository access.'
    exit 2
}

if ($InstallMissing) {
    foreach ($definition in $missing) {
        Write-Output ("INSTALLING {0} from {1}" -f $definition.Name, $definition.Repo)
        Install-Skill $definition
    }
}

$failed = @()
foreach ($definition in $definitions) {
    $path = Get-SkillPath $definition
    if ($path) {
        Write-Output ("READY {0} (path: {1}; source: {2})" -f $definition.Name, $path, $definition.Repo)
    }
    else {
        Write-Output ("NOT READY {0}" -f $definition.Name)
        $failed += $definition.Name
    }
}

if ($failed.Count -gt 0) {
    exit 1
}
Write-Output '3/3 READY'
