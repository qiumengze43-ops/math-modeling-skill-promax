$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$expected = @(
    @{ Name = 'math-modeling-skill'; RelativePath = 'upstream-skills\math-modeling-skill\SKILL.md' },
    @{ Name = 'math-modeling-solver'; RelativePath = 'upstream-skills\math-modeling-skills\skills\math-modeling-solver\SKILL.md' },
    @{ Name = 'math-modeling-paper'; RelativePath = 'upstream-skills\math-modeling-skills\skills\math-modeling-paper\SKILL.md' }
)

foreach ($definition in $expected) {
    $skillFile = Join-Path $projectRoot $definition.RelativePath
    if (-not (Test-Path -LiteralPath $skillFile)) {
        throw "Missing bundled Skill source: $skillFile"
    }
    $match = Select-String -LiteralPath $skillFile -Pattern '^name:\s*(.+?)\s*$' | Select-Object -First 1
    if (-not $match -or $match.Matches[0].Groups[1].Value.Trim() -ne $definition.Name) {
        throw "Bundled Skill name mismatch: $skillFile"
    }
}

Write-Output 'BUNDLED_SOURCES_CHECK_PASS'
