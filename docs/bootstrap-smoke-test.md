# Bootstrap and Upstream Skill Smoke Test

This record documents the bootstrap state of the reusable project layer. It is not a competition result.

## Installed entry points

| Actual Skill entry point | Source repository | Intended responsibility | Status |
|---|---|---|---|
| `math-modeling-skill` | `skillforCUMCM/math-modeling-skill-pro` | evidence boundary, mechanism, dependencies, cases, model audit | FOUND |
| `math-modeling-solver` | `Lupynow/math-modeling-skills` | methods, cookbooks, solver and code scaffolds | FOUND |
| `math-modeling-paper` | `Lupynow/math-modeling-skills` | paper, abstract, figure, memo/letter and formatting support | FOUND |

The second repository exposes two independent Skill entry points. The project routes them separately and does not merge them.

## Smoke results

### Skill Pro

The runtime entry point is `math-modeling-skill`; `skillforCUMCM/math-modeling-skill-pro` is the source repository name.

- The case-search entry point returned three structurally matched case cards for a small-sample forecasting query.
- The contract separates evidence boundary, mechanism, dependencies, candidate comparison, and validation from paper drafting.
- Result: `PASS` for responsibility and discovery smoke test.

### Solver

- The installed resource set contains an integer/MIP template and optimization cookbook.
- The original integer-programming template ran in a temporary environment with `scipy 1.18.0`, `pulp 3.3.2`, and `openpyxl 3.1.5`.
- Template result: `Optimal`, facility-location objective `655.00`, and LP relaxation output `0.0000`.
- Project smoke result: `scripts/smoke_test_milp.py` returned `Optimal`, objective `12.0`, `x=4`, `y=0`, and capacity left-hand side `4.0` for `max 3x+2y` subject to `x+y<=4`, `x,y∈Z>=0`.
- Result: `PASS` for actual solver execution and independent feasibility check.

The dependencies were installed only in a temporary environment and are not project dependencies.

### Paper

The paper entry point is installed for later writing stages. It is not invoked during the G1-G4 dry run; paper drafting is blocked until the modeling records and G5-G6 validation are complete.

## Routing decision

`Codex + AGENTS.md` remains the controller. The upstream entry points provide scoped capabilities only. No local upstream knowledge base, case collection, code template collection, or mathematical-modeling `SKILL.md` is created here.
