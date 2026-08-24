# Mathematical Modeling Zero-to-Ready

Promax is a portable source bundle for a global **router Skill plus three independent upstream Skills** for CUMCM, MCM, and ICM work. The router owns the G1-G6 workflow; the three domain Skills remain separate and are only reached through the router.

## Bundle layout

```text
.
|-- AGENTS.md
|-- skills/
|   `-- math-modeling-promax/SKILL.md
|-- upstream-skills/
|   |-- math-modeling-skill/
|   `-- math-modeling-skills/
|       `-- skills/
|           |-- math-modeling-solver/
|           `-- math-modeling-paper/
|-- modeling/
|-- docs/
`-- scripts/
```

The two upstream repositories are pinned as Git submodules. Solver and Paper remain independent Skill entry points inside the Lupynow repository.

## Install globally on a new computer

Clone the project with its submodules:

```powershell
git clone --recurse-submodules <promax-repository>
cd math-modeling-skill-promax
.\scripts\bootstrap.ps1 -InitializeUpstreams -InstallCopy
```

This copies the complete four Skill directories, including the global Promax router, into the global Codex discovery directory:

```text
C:\Users\<user>\.agents\skills\
|-- math-modeling-promax\  # global router; mandatory entry point
|-- math-modeling-skill\
|-- math-modeling-solver\
`-- math-modeling-paper\
```

These are physical folders, not junctions. The project remains the portable source bundle; the global directory is the installed copy.

## Bootstrap modes

```powershell
# Validate current global installation without writing
.\scripts\bootstrap.ps1

# Install or refresh complete physical Skill folders globally
.\scripts\bootstrap.ps1 -InstallCopy

# Initialize missing submodules and install globally
.\scripts\bootstrap.ps1 -InitializeUpstreams -InstallCopy
```

The old `-Register` flag remains only as a junction-compatibility command. It is not the recommended installation mode.

Only the four named Promax directories are replaced by `-InstallCopy`; other global Skills are untouched. The installed `math-modeling-promax` router must be the entry point; do not invoke the three lower Skills directly.

During `-InstallCopy`, the three lower global `SKILL.md` descriptions receive the prefix `Use only when routed by math-modeling-promax; do not invoke this downstream Skill directly.` The upstream submodule files remain unchanged.

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
