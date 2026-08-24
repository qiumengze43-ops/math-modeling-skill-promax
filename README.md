[中文版](README.zh-CN.md) | English | [MIT License](LICENSE)

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
git clone --recurse-submodules https://github.com/qiumengze43-ops/math-modeling-skill-promax.git
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

## Installation scope

This installs the exact version recorded by this repository: the parent Git commit and both submodule pointers are fixed. The installer does not pull or track newer upstream versions.

Run this once on the computer where you want to use this version:

```powershell
git clone --recurse-submodules https://github.com/qiumengze43-ops/math-modeling-skill-promax.git
cd math-modeling-skill-promax
.\scripts\bootstrap.ps1 -InitializeUpstreams -InstallCopy
```

The command installs four physical directories under `C:\Users\<user>\.agents\skills\`. It replaces only the four Promax directories and leaves unrelated global Skills untouched. The installed `math-modeling-promax` router is the required entry point.

The three lower global `SKILL.md` descriptions receive a route-only description overlay during installation; the upstream submodule files remain unchanged.

## Verify installation

```powershell
.\scripts\bootstrap.ps1
```

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
