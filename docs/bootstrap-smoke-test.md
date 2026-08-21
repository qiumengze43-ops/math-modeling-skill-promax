# Bootstrap and Upstream Skill Smoke Test

This record documents the bootstrap state of the reusable project layer. It is not a competition result.

## Installed entry points

| Entry point | Source | Intended responsibility | Status |
|---|---|---|---|
| `math-modeling-skill-pro` | `skillforCUMCM/math-modeling-skill-pro` | evidence boundary, mechanism, dependencies, cases, model audit | FOUND |
| `math-modeling-solver` | `Lupynow/math-modeling-skills` | methods, cookbooks, solver and code scaffolds | FOUND |
| `math-modeling-paper` | `Lupynow/math-modeling-skills` | paper, abstract, figure, memo/letter and formatting support | FOUND |

The second repository exposes two independent Skill entry points. The project routes them separately and does not merge them.

## Smoke results

### Skill Pro

Prompt shape: a system must forecast demand and allocate resources under capacity and cost constraints; return only problem structure, mechanism, A/B/C candidates, and validation design.

- Evidence boundary and problem decomposition are represented in the installed Skill contract.
- The case-search entry point ran successfully and returned three structurally matched case cards for a small-sample forecasting query.
- The contract explicitly excludes inventing data, automatically writing a complete paper, or selecting a model only by keyword.
- Result: `PASS` for responsibility and discovery smoke test.

### Solver

Prompt shape: a constrained MILP is already specified; provide an implementation route, Python/MATLAB scaffold direction, and feasibility checks without redoing the whole contest decomposition.

- The installed resource set contains an integer/MIP template and optimization cookbook.
- The template identifies PuLP as the default open-source route, with Gurobi/SCIP alternatives, and exposes constraint and solver-status checks.
- Python syntax compilation passed.
- Direct execution was `PASS WITH RISK`: the current Python environment lacks `scipy`, so the template raised `ModuleNotFoundError: No module named 'scipy'` before solving. This dependency is not copied into the project.

### Paper

The paper entry point is installed for later writing stages. It is not invoked during the G1-G4 dry run; paper drafting is blocked until the modeling records and G5-G6 validation are complete.

## Routing decision

`Codex + AGENTS.md` remains the controller. The upstream entry points provide scoped capabilities only. No local upstream knowledge base, case collection, code template collection, or mathematical-modeling `SKILL.md` is created here.
