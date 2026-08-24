# Bootstrap and Upstream Skill Smoke Test

This record documents the reusable Skill Bundle state. It is not a competition result.

## Bundled entry points

| Skill | Repository-local source | Responsibility | Check |
|---|---|---|---|
| `math-modeling-skill` | `upstream-skills/math-modeling-skill` | mechanism, evidence boundary, dependencies, cases, model audit | `test_bundled_sources.ps1` |
| `math-modeling-solver` | `upstream-skills/math-modeling-skills/skills/math-modeling-solver` | methods, cookbooks, solver and code scaffolds | `test_bundled_sources.ps1` |
| `math-modeling-paper` | `upstream-skills/math-modeling-skills/skills/math-modeling-paper` | paper, abstract, figures, memo/letter and formatting | `test_bundled_sources.ps1` |

The Lupynow repository exposes two independent entry points; Promax routes them separately.

## Local bootstrap smoke test

```powershell
.\scripts\test_bundled_sources.ps1
.\scripts\test_bootstrap_bundle.ps1
.\scripts\test_bootstrap_install.ps1
```

These tests use local fixture data or the pinned submodules. They verify source names, junction creation, idempotent registration, conflict protection, and the `3/3 READY` result. They do not clone from GitHub.

## Ownership boundary

`AGENTS.md` remains the controller for G1-G6 routing. Upstream Skills own their own instructions and references. No local upstream knowledge base, case collection, code-template collection, or mathematical-modeling `SKILL.md` is created here.

