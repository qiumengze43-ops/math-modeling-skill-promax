# Cross-Machine Bootstrap

Promax is a Skill Bundle + Orchestrator. Bootstrap discovers the three independent upstream Skill entry points from repository-local submodules and, when explicitly requested, registers junctions in the Codex discovery directory. It does not create a fourth Skill and does not copy upstream knowledge bases into Promax.

## Repository-local sources

| Discovery name | Local source | Upstream repository |
|---|---|---|
| `math-modeling-skill` | `upstream-skills/math-modeling-skill` | `skillforCUMCM/math-modeling-skill-pro` |
| `math-modeling-solver` | `upstream-skills/math-modeling-skills/skills/math-modeling-solver` | `Lupynow/math-modeling-skills` |
| `math-modeling-paper` | `upstream-skills/math-modeling-skills/skills/math-modeling-paper` | `Lupynow/math-modeling-skills` |

The two submodule commits pin the exact upstream versions. Update a Skill by updating its submodule commit, then rerunning the local tests.

## Windows commands

From the project root:

```powershell
# Validate bundled sources and current discovery links; no network and no writes
.\scripts\bootstrap.ps1

# Initialize missing submodule worktrees; may use the network
.\scripts\bootstrap.ps1 -InitializeUpstreams

# Create or validate three directory junctions in the default discovery root
.\scripts\bootstrap.ps1 -Register

# First-time setup in one command
.\scripts\bootstrap.ps1 -InitializeUpstreams -Register

# Use an explicit discovery root for tests or a legacy installation
.\scripts\bootstrap.ps1 -SkillsRoot 'C:\Users\<user>\.agents\skills'
.\scripts\bootstrap.ps1 -SkillsRoot 'C:\Users\<user>\.codex\skills' -Register
```

The default root is `C:\Users\<user>\.agents\skills`. Ordinary validation and registration use only local files. Network access is limited to explicit submodule initialization.

## Result states

- `READY <name>`: the discovery entry is a junction to the expected repository-local Skill.
- `MISSING <name>`: the source or discovery entry is absent; use `-InitializeUpstreams` for missing submodules or `-Register` for missing links.
- `CONFLICT <name>`: an existing directory, file, broken link, or link to another target occupies the path.

Bootstrap never deletes, moves, or overwrite[s] an existing discovery entry. It accepts an existing correct junction and leaves every conflict untouched. Resolve a conflict manually, then rerun the command.

## Verification

Run the local checks without network access:

```powershell
.\scripts\test_bundled_sources.ps1
.\scripts\test_bootstrap_bundle.ps1
.\scripts\test_bootstrap.ps1
.\scripts\test_bootstrap_default_root.ps1
.\scripts\test_bootstrap_install.ps1
.\scripts\test_bundle_docs.ps1
```

The upstream Solver and Paper entry points remain separate. Python/scientific-computing dependencies are not installed by bootstrap.

