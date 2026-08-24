# Global Skill Installation Smoke Test

This record documents the reusable Skill Bundle installation. It is not a competition result.

## Installed entry points

| Skill | Repository source | Global installation |
|---|---|---|
| `math-modeling-promax` | `skills/math-modeling-promax` | `%USERPROFILE%\.agents\skills\math-modeling-promax` |
| `math-modeling-skill` | `upstream-skills/math-modeling-skill` | `%USERPROFILE%\.agents\skills\math-modeling-skill` |
| `math-modeling-solver` | `upstream-skills/math-modeling-skills\skills\math-modeling-solver` | `%USERPROFILE%\.agents\skills\math-modeling-solver` |
| `math-modeling-paper` | `upstream-skills/math-modeling-skills\skills\math-modeling-paper` | `%USERPROFILE%\.agents\skills\math-modeling-paper` |

The installed `math-modeling-promax` directory is the mandatory global router entry point; it must route to the three lower Skills. The installed directories are physical copies. The three lower global descriptions also carry the route-only prefix; the upstream submodule descriptions are not modified. They do not depend on junctions or on the project remaining at the same path.

## Smoke commands

```powershell
.\scripts\bootstrap.ps1 -InstallCopy
.\scripts\test_global_router.ps1
.\scripts\test_bootstrap_install_copy.ps1
.\scripts\test_bootstrap_bundle.ps1
```

The checks verify source names, complete physical copies, stale-file replacement, junction compatibility, and the `4/4 READY` result.

## Ownership boundary

The project owns the router source and pinned upstream sources. The global directory owns the installed copies used by Codex. This smoke test covers only the pinned version installed from the current repository snapshot; it does not track upstream updates.
