# Mathematical Modeling Zero-to-Ready

Promax is a project-level **Skill Bundle + Orchestrator** for CUMCM, MCM, and ICM work. It owns the G1-G6 workflow and reusable modeling records; it is not a fourth mathematical-modeling Skill.

## Bundle layout

```text
.
|-- AGENTS.md
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

This copies the complete three Skill directories into the global Codex discovery directory:

```text
C:\Users\<user>\.agents\skills\
├── math-modeling-skill\
├── math-modeling-solver\
└── math-modeling-paper\
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

Only the three named mathematical-modeling directories are replaced by `-InstallCopy`; other global Skills are untouched.

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

