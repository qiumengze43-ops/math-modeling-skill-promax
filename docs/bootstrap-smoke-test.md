# Global Skill Installation Smoke Test

This record documents the reusable Skill Bundle installation. It is not a competition result.

## Installed entry points

| Skill | Repository source | Global installation |
|---|---|---|
| `math-modeling-skill` | `upstream-skills/math-modeling-skill` | `%USERPROFILE%\.agents\skills\math-modeling-skill` |
| `math-modeling-solver` | `upstream-skills/math-modeling-skills\skills\math-modeling-solver` | `%USERPROFILE%\.agents\skills\math-modeling-solver` |
| `math-modeling-paper` | `upstream-skills/math-modeling-skills\skills\math-modeling-paper` | `%USERPROFILE%\.agents\skills\math-modeling-paper` |

The installed directories are physical copies. They do not depend on junctions or on the project remaining at the same path.

## Smoke commands

```powershell
.\scripts\bootstrap.ps1 -InstallCopy
.\scripts\test_bootstrap_install_copy.ps1
.\scripts\test_bootstrap_bundle.ps1
```

The checks verify source names, complete physical copies, stale-file replacement, junction compatibility, and the `3/3 READY` result.

## Ownership boundary

The project owns orchestration and pinned upstream sources. The global directory owns the installed copies used by Codex. Updating the project does not change the global installation until `-InstallCopy` is run again.
