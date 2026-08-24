# Promax Skill Bundle Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Promax a portable Skill Bundle + Orchestrator with two pinned upstream submodules and safe local-to-Codex discovery junctions for three independent Skills.

**Architecture:** Add the Pro Skill repository and the Lupynow multi-Skill repository as Git submodules under `upstream-skills/`. Refactor `scripts/bootstrap.ps1` into a local validator with explicit `-InitializeUpstreams` and `-Register` mutations; registration creates or validates directory junctions under the selected discovery root and never overwrites conflicts.

**Tech Stack:** PowerShell 5+/Windows directory junctions, Git submodules, existing PowerShell smoke tests, Markdown documentation, `git diff --check`.

**Spec:** `docs/superpowers/specs/2026-08-24-skill-bundle-design.md`

## Global Constraints

- Keep `math-modeling-skill`, `math-modeling-solver`, and `math-modeling-paper` as three independent upstream Skills; do not create a fourth project-local mathematical-modeling `SKILL.md`.
- Pin upstream content with Git submodule commits; do not copy or flatten upstream repositories into Promax-owned files.
- Default bootstrap execution is read-only validation; only `-InitializeUpstreams` and `-Register` may mutate state.
- Never delete, move, or overwrite an existing discovery directory or link; report conflicts with actionable paths.
- Default discovery root is `C:\Users\<user>\.agents\skills`; `-SkillsRoot` remains available for tests.
- Network access is allowed only for explicit submodule initialization, not for ordinary validation or registration.
- Preserve the G1-G6 workflow and the four `modeling/` source-of-truth records.

---

### Task 1: Add pinned upstream sources

**Files:**
- Create: `.gitmodules`
- Create: `upstream-skills/math-modeling-skill/` Git submodule at `https://github.com/skillforCUMCM/math-modeling-skill-pro.git`
- Create: `upstream-skills/math-modeling-skills/` Git submodule at `https://github.com/Lupynow/math-modeling-skills.git`

**Interfaces:**
- Produces these repository-local paths for later tasks:
  - `upstream-skills/math-modeling-skill/SKILL.md`
  - `upstream-skills/math-modeling-skills/skills/math-modeling-solver/SKILL.md`
  - `upstream-skills/math-modeling-skills/skills/math-modeling-paper/SKILL.md`

- [ ] **Step 1: Write the failing source-layout check**

Add `scripts/test_bundled_sources.ps1` with assertions that the three expected `SKILL.md` files exist and contain the exact expected `name:` values. Run it before adding submodules; it must fail with a missing-source diagnostic.

- [ ] **Step 2: Run the check and verify the expected failure**

Run:

```powershell
.\scripts\test_bundled_sources.ps1
```

Expected: non-zero exit because `upstream-skills/` is not populated.

- [ ] **Step 3: Add the submodules**

Run:

```powershell
git submodule add https://github.com/skillforCUMCM/math-modeling-skill-pro.git upstream-skills/math-modeling-skill
git submodule add https://github.com/Lupynow/math-modeling-skills.git upstream-skills/math-modeling-skills
```

Confirm the exact three `SKILL.md` files and names with `Get-Content`/ `Select-String`.

- [ ] **Step 4: Run the source-layout check and verify it passes**

Run the same PowerShell check. Expected: `BUNDLED_SOURCES_CHECK_PASS` and both submodule paths appear in `git submodule status`.

- [ ] **Step 5: Commit**

```powershell
git add .gitmodules upstream-skills scripts/test_bundled_sources.ps1
git commit -m "feat: bundle upstream modeling skill sources"
```

### Task 2: Specify bootstrap behavior with failing tests

**Files:**
- Create: `scripts/test_bootstrap_bundle.ps1`
- Modify: `scripts/test_bootstrap.ps1`
- Modify: `scripts/test_bootstrap_default_root.ps1`
- Replace: `scripts/test_bootstrap_install.ps1` with a local registration test

**Interfaces:**
- Tests invoke `scripts/bootstrap.ps1` with `-ProjectRoot <fixture>` and `-SkillsRoot <temporary-root>`.
- The fixture contains three minimal valid Skill directories, allowing tests to run without network access.

- [ ] **Step 1: Write failing tests for validation, registration, idempotence, and conflicts**

Create a temporary fixture with this layout and minimal `SKILL.md` files:

```text
fixture\upstream-skills\math-modeling-skill\SKILL.md
fixture\upstream-skills\math-modeling-skills\skills\math-modeling-solver\SKILL.md
fixture\upstream-skills\math-modeling-skills\skills\math-modeling-paper\SKILL.md
```

Assert that read-only mode fails when discovery links are absent, `-Register` creates four junctions and reports `4/4 READY`, a second registration is idempotent, and an unrelated existing directory causes a non-zero conflict while remaining intact.

- [ ] **Step 2: Run the focused tests and verify they fail**

Run:

```powershell
.\scripts\test_bootstrap_bundle.ps1
.\scripts\test_bootstrap_default_root.ps1
```

Expected: the bundle test fails because `bootstrap.ps1` does not yet accept `-ProjectRoot`/`-Register` and still implements download/copy behavior.

- [ ] **Step 3: Commit the red tests**

```powershell
git add scripts/test_bootstrap_bundle.ps1 scripts/test_bootstrap.ps1 scripts/test_bootstrap_default_root.ps1 scripts/test_bootstrap_install.ps1
git commit -m "test: define bundled skill bootstrap contract"
```

### Task 3: Refactor bootstrap into a local validator and registrar

**Files:**
- Modify: `scripts/bootstrap.ps1`
- Test: `scripts/test_bootstrap_bundle.ps1`
- Test: `scripts/test_bootstrap.ps1`
- Test: `scripts/test_bootstrap_default_root.ps1`

**Interfaces:**
- Parameters: `[string]$SkillsRoot`, `[switch]$InitializeUpstreams`, `[switch]$Register`, and `[string]$ProjectRoot`.
- Internal definition records map each discovery name to a repository-local relative path.
- `Get-SkillName` reads the first `name:` line in a local `SKILL.md`.
- `Test-BundledSources` validates all three local source paths before discovery checks.
- `Register-SkillLink` creates a directory junction only when the destination is absent; it accepts an existing junction resolving to the expected target and throws a conflict otherwise.

- [ ] **Step 1: Implement source definitions and path validation**

Replace GitHub repository-copy definitions with local relative targets. Resolve every target against `ProjectRoot`, verify `SKILL.md), and verify exact Skill names. In read-only mode, missing submodule worktrees produce an instruction to run `-InitializeUpstreams`.

- [ ] **Step 2: Implement explicit submodule initialization**

When `-InitializeUpstreams` is set, run:

```powershell
git -C $ProjectRoot submodule update --init --recursive
```

Propagate a non-zero Git exit code with captured output. Do not invoke Git or access the network when the flag is absent.

- [ ] **Step 3: Implement safe junction registration**

For each definition, inspect the destination with `Get-Item -Force` and `LinkType`/`Target`. Create the parent directory and use:

```powershell
New-Item -ItemType Junction -Path $destination -Target $source | Out-Null
```

Accept an existing junction whose resolved full target equals the source full path. Reject existing directories, files, broken links, or links to another target without deleting them.

- [ ] **Step 4: Keep default validation read-only and preserve status output**

Default execution validates sources and existing discovery links. `-Register` performs registration before the final validation pass. Report `READY <name>`, `MISSING <name>`, or `CONFLICT <name>` and finish with `4/4 READY` only when all four are valid.

- [ ] **Step 5: Run focused tests and verify green**

Run:

```powershell
.\scripts\test_bootstrap_bundle.ps1
.\scripts\test_bootstrap.ps1
.\scripts\test_bootstrap_default_root.ps1
```

Expected: all report their `*_PASS` markers; no network clone occurs.

- [ ] **Step 6: Commit**

```powershell
git add scripts/bootstrap.ps1 scripts/test_bootstrap_bundle.ps1 scripts/test_bootstrap.ps1 scripts/test_bootstrap_default_root.ps1 scripts/test_bootstrap_install.ps1
git commit -m "feat: register bundled skills through junctions"
```

### Task 4: Update documentation and user-facing commands

**Files:**
- Modify: `README.md`
- Modify: `docs/bootstrap.md`
- Modify: `docs/bootstrap-smoke-test.md`
- Modify: `docs/workflow.md`
- Modify: `AGENTS.md`

**Interfaces:**
- Documentation uses `Skill Bundle + Orchestrator` terminology.
- First-time setup documents `git clone --recurse-submodules` and `bootstrap.ps1 -InitializeUpstreams -Register`.
- Routine validation documents `bootstrap.ps1`; alternate roots use `-SkillsRoot`.
- Conflict handling and the no-overwrite rule are explicit.

- [ ] **Step 1: Write documentation assertions**

Extend `test_bootstrap_bundle.ps1` to assert that `README.md` and `docs/bootstrap.md` mention `upstream-skills`, `-Register`, `-InitializeUpstreams`, and the no-overwrite rule.

- [ ] **Step 2: Run the documentation test and verify it fails**

Run the focused test. Expected: failure because current docs still describe download-and-copy installation.

- [ ] **Step 3: Update the documentation**

Replace global-download language with the local source layout, discovery-link mapping, update workflow, explicit mutation flags, and unchanged G1-G6 routing. Keep the four modeling record contracts unchanged.

- [ ] **Step 4: Run documentation assertions and inspect the Markdown text**

Expected: all required terms are present and no section instructs users to copy upstream Skill content into Promax.

- [ ] **Step 5: Commit**

```powershell
git add README.md docs/bootstrap.md docs/bootstrap-smoke-test.md docs/workflow.md AGENTS.md scripts/test_bootstrap_bundle.ps1
git commit -m "docs: describe Promax as a skill bundle"
```

### Task 5: Full verification and handoff

**Files:**
- Test: `scripts/test_bundled_sources.ps1`
- Test: `scripts/test_bootstrap_bundle.ps1`
- Test: `scripts/test_bootstrap.ps1`
- Test: `scripts/test_bootstrap_default_root.ps1`
- Test: `scripts/test_bootstrap_install.ps1`
- Test: existing Python tests under `scripts/`

- [ ] **Step 1: Validate PowerShell parsing**

Run:

```powershell
$files = Get-ChildItem scripts -Filter '*.ps1'
foreach ($file in $files) { [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$null) | Out-Null }
```

Expected: no parser errors.

- [ ] **Step 2: Run the complete local test set**

Run:

```powershell
.\scripts\test_bundled_sources.ps1
.\scripts\test_bootstrap_bundle.ps1
.\scripts\test_bootstrap.ps1
.\scripts\test_bootstrap_default_root.ps1
python -m unittest discover -s scripts -p 'test_*.py'
```

Expected: every test passes without network access.

- [ ] **Step 3: Verify repository state and diff hygiene**

Run:

```powershell
git submodule status
git diff --check
git status --short
git diff --stat HEAD~4..HEAD
```

Expected: both submodules are pinned, no whitespace errors exist, and only intended bundle/bootstrap/docs files changed.

- [ ] **Step 4: Exercise first-time setup instructions**

In a temporary Skill root, run:

```powershell
.\scripts\bootstrap.ps1 -SkillsRoot $temporaryRoot -Register
```

Expected: `4/4 READY`, four junctions target the repository-local sources, and a second run is idempotent.

- [ ] **Step 5: Commit verification-only adjustments if needed**

If verification reveals a defect, add a failing regression test first, fix the minimal implementation, rerun the complete suite, and commit with a focused message. Otherwise leave the tree clean and report the evidence.

