# Cross-Machine Bootstrap

Promax is a portable source bundle for a global router Skill plus three independent upstream Skills. Bootstrap installs complete physical copies into the global Codex Skill directory.

## Repository-local sources

| Skill | Local source | Upstream repository |
|---|---|---|
| `math-modeling-promax` | `skills/math-modeling-promax` | project-owned router |
| `math-modeling-skill` | `upstream-skills/math-modeling-skill` | `skillforCUMCM/math-modeling-skill-pro` |
| `math-modeling-solver` | `upstream-skills/math-modeling-skills/skills/math-modeling-solver` | `Lupynow/math-modeling-skills` |
| `math-modeling-paper` | `upstream-skills/math-modeling-skills/skills/math-modeling-paper` | `Lupynow/math-modeling-skills` |

## Install this pinned version

This repository records one exact installation version: the parent Git commit and both submodule pointers are fixed. Bootstrap does not pull or track newer upstream versions.

Run once from the repository root:

```powershell
git clone --recurse-submodules https://github.com/qiumengze43-ops/math-modeling-skill-promax.git
cd math-modeling-skill-promax
.\scripts\bootstrap.ps1 -InitializeUpstreams -InstallCopy
```

The default destination is `C:\Users\<user>\.agents\skills`.

## Install behavior

`-InstallCopy` validates all four bundled `SKILL.md` files, removes only the four named old deployment directories, and copies every file from each repository-local Skill source into the global destination. This produces a clean physical installation of the pinned version.

The installed `math-modeling-promax` router is the mandatory entry point and explicitly forbids direct calls to the three lower Skills. It never touches unrelated directories such as `pdf-efficient-reader`, `hf-cli`, or `grilling`.

For physical installs, bootstrap also overlays each lower Skill description with `Use only when routed by math-modeling-promax; do not invoke this downstream Skill directly.` This overlay is applied only to the global copy, so the upstream submodules stay pristine.



## Result states

- `READY <name>`: the global Skill directory is valid.
- `MISSING <name>`: source or global directory is absent; rerun the same pinned-version installation command shown above.
- `CONFLICT <name>`: a non-matching deployment occupies the expected path during validation.

## Verification

```powershell
.\scripts\test_global_router.ps1
.\scripts\test_bundled_sources.ps1
.\scripts\test_bootstrap_install_copy.ps1
.\scripts\test_bootstrap_bundle.ps1
.\scripts\test_bootstrap_install.ps1
.\scripts\test_bundle_docs.ps1
```
