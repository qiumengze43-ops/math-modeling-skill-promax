# Promax Skill Bundle Design

## Goal

Turn `math-modeling-skill-promax` into a portable mathematical-modeling workbench that contains its orchestration layer, project records, and pinned upstream Skill sources in one repository, while keeping the three upstream Skills independent and unmodified.

The repository remains a project-level harness, not a fourth mathematical-modeling Skill.

## Chosen Architecture

Use two Git submodules under `upstream-skills/`:

```text
math-modeling-skill-promax/
|-- AGENTS.md
|-- README.md
|-- .gitmodules
|-- upstream-skills/
|   |-- math-modeling-skill/       # skillforCUMCM/math-modeling-skill-pro
|   `-- math-modeling-skills/      # Lupynow/math-modeling-skills
|       `-- skills/
|           |-- math-modeling-solver/
|           `-- math-modeling-paper/
|-- modeling/
|-- docs/
`-- scripts/
```

The Lupynow repository is included once because it owns both Solver and Paper. The physical source layout therefore reflects upstream repository ownership instead of duplicating one repository into two submodules.

The three Codex discovery entries resolve to:

| Discovery name | Repository-local target |
|---|---|
| `math-modeling-skill` | `upstream-skills/math-modeling-skill` |
| `math-modeling-solver` | `upstream-skills/math-modeling-skills/skills/math-modeling-solver` |
| `math-modeling-paper` | `upstream-skills/math-modeling-skills/skills/math-modeling-paper` |

## Ownership and Update Boundary

- Promax owns orchestration, modeling records, documentation, bootstrap logic, and integration tests.
- Each upstream repository owns its Skill instructions, references, cases, scripts, and templates.
- Promax does not edit, flatten, copy, or vendor upstream Skill content.
- Git submodule commits pin reproducible upstream versions.
- Updating upstream Skills means updating the relevant submodule commit and then running integration validation.
- A normal clone uses `git clone --recurse-submodules`. An existing clone uses `git submodule update --init --recursive`.

## Bootstrap Contract

`scripts/bootstrap.ps1` changes from a downloader/copier into a validator and registrar.

### Default check

Running the script without mutation flags:

```powershell
.\scripts\bootstrap.ps1
```

checks:

1. both submodule worktrees are populated;
2. all three repository-local `SKILL.md` files exist and declare the expected names;
3. each discovery entry under the selected Skill root resolves to the expected repository-local target;
4. the final state is reported as `3/3 READY` or with actionable diagnostics.

The default Skill root remains `~/.agents/skills`, with `-SkillsRoot` available for tests and non-default installations.

### Initialize upstream sources

An explicit flag initializes missing submodule worktrees:

```powershell
.\scripts\bootstrap.ps1 -InitializeUpstreams
```

This is the only bootstrap path that may require network access. It runs Git submodule initialization; it does not clone and copy individual Skills.

### Register discovery links

An explicit flag registers the three entries:

```powershell
.\scripts\bootstrap.ps1 -Register
```

On Windows, registration uses directory junctions so administrator privileges and Developer Mode are not normally required. Each junction points directly to the corresponding repository-local Skill directory, leaving only one physical copy of the files.

`-InitializeUpstreams` and `-Register` may be combined for first-time setup.

### Conflict handling

Bootstrap never silently replaces an existing discovery directory or link.

- An existing link that resolves to the expected target is accepted.
- An existing valid Skill directory or link that resolves elsewhere is reported as a conflict.
- A broken link is reported as a conflict.
- The user resolves conflicts explicitly; bootstrap provides the paths but does not delete, move, or overwrite them.

This preserves independently installed global Skills and prevents accidental data loss.

## Orchestration Changes

`AGENTS.md`, `README.md`, and `docs/workflow.md` will describe Promax as a `Skill Bundle + Orchestrator` rather than a harness that depends on separately downloaded global copies.

Routing remains unchanged:

- `math-modeling-skill` handles mechanism, evidence boundaries, model comparison, audit, validation planning, and defensible innovation;
- `math-modeling-solver` handles detailed methods, implementation scaffolds, solvers, and implementation-oriented validation;
- `math-modeling-paper` handles paper structure, writing, figures, citations, and formatting after the modeling record is ready.

The G1-G6 gate workflow and the four modeling source-of-truth files remain unchanged.

## Migration

1. Add the two upstream repositories as pinned Git submodules.
2. Replace download-and-copy bootstrap behavior with local validation, optional submodule initialization, and optional junction registration.
3. Update bootstrap tests before changing production behavior.
4. Update documentation and the repository tree description.
5. Leave existing external Skill installations untouched. If they conflict with the desired links, bootstrap reports the exact paths and stops.

No project-local mathematical-modeling `SKILL.md` is introduced.

## Verification

Automated tests cover:

- failure when bundled upstream sources are absent or invalid;
- validation of all three expected Skill names from the two-source layout;
- registration of three links into a temporary Skill root;
- idempotent repeated registration;
- refusal to replace an unrelated existing directory or link;
- default Skill root remains `.agents/skills`;
- PowerShell syntax validation;
- existing Python tests and `git diff --check` remain clean.

The network-dependent check initializes real submodules only when run explicitly. CI validates pinned submodule configuration and local bootstrap behavior without relying on live GitHub availability.

## Non-Goals

- Merging three Skills into one `SKILL.md`.
- Copying upstream knowledge bases into Promax-owned files.
- Automatically modifying upstream Skill content.
- Automatically deleting or replacing existing global Skill installations.
- Installing Python, MATLAB, solver, or scientific-computing dependencies.
- Changing the G1-G6 modeling methodology.

