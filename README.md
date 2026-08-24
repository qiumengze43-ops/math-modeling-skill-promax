# Mathematical Modeling Zero-to-Ready

Promax is a project-level **Skill Bundle + Orchestrator** for CUMCM, MCM, and ICM work. It owns the G1-G6 workflow and the reusable modeling records; it is not a fourth mathematical-modeling Skill.

## Bundle layout

```text
.
|-- AGENTS.md
|-- upstream-skills/
|   |-- math-modeling-skill/                 # skillforCUMCM/math-modeling-skill-pro
|   `-- math-modeling-skills/               # Lupynow/math-modeling-skills
|       `-- skills/
|           |-- math-modeling-solver/
|           `-- math-modeling-paper/
|-- modeling/
|-- docs/
`-- scripts/
```

The two upstream repositories are pinned as Git submodules. Solver and Paper remain two independent Skill entry points inside the Lupynow repository. Promax never merges, copies, or edits their upstream knowledge bases.

## First-time setup

Clone with the upstream sources:

```powershell
git clone --recurse-submodules <promax-repository>
cd math-modeling-skill-promax
.\scripts\bootstrap.ps1 -InitializeUpstreams -Register
```

If the repository was cloned without submodules, run `git submodule update --init --recursive` directly or use the explicit `-InitializeUpstreams` flag.

## Bootstrap and discovery

Routine validation is read-only:

```powershell
.\scripts\bootstrap.ps1
```

Register the three repository-local Skills into the Codex discovery root with directory junctions:

```powershell
.\scripts\bootstrap.ps1 -Register
```

The default discovery root is `C:\Users\<user>\.agents\skills`. Use `-SkillsRoot` for another root or for tests. Registration keeps one physical copy of each Skill.

Bootstrap never silently overwrite an existing directory or link. A valid junction to the expected target is accepted; a conflicting, broken, or unrelated entry is reported and left untouched.

## Modeling workflow

Start every competition at G1 and keep these files as the source of truth:

- `modeling/assumptions.md`
- `modeling/model_cards.md`
- `modeling/implementation_cards.md`
- `modeling/validation_and_limits.md`

The upstream routing remains:

- `math-modeling-skill`: mechanism, evidence boundary, dependencies, candidate comparison, audit, validation, and defensible innovation;
- `math-modeling-solver`: detailed methods, algorithms, solver/code scaffolds, and implementation validation;
- `math-modeling-paper`: paper structure, abstract, figures, citations, memo/letter, and formatting after modeling records are validated.

Read `docs/workflow.md` for the G1-G6 gate contracts and `docs/bootstrap.md` for bootstrap diagnostics.
