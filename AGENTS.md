# Mathematical Modeling Project Orchestration

This repository is the portable source bundle for the global `math-modeling-promax` router and three independent mathematical-modeling Skills. The router is installed globally from `skills/math-modeling-promax/SKILL.md`; it is not a merged copy of the upstream Skills and must route all downstream calls.

## Orchestrator and upstream Skill routing

1. The globally installed `math-modeling-promax` Skill is the mandatory entry point. In this repository, `AGENTS.md` supplies the project-specific gate and artifact contracts; together they decide the current gate, required artifacts, and which downstream capability is needed.
2. Invoke `math-modeling-skill` for evidence-boundary analysis, real-world mechanism and dependency analysis, structurally similar case retrieval, candidate-model comparison, modeling audit, validation/sensitivity planning, and defensible innovation planning. Its source repository is `skillforCUMCM/math-modeling-skill-pro`.
3. Invoke `math-modeling-solver` for detailed method references, algorithm cookbooks, Python/MATLAB scaffolds, solver guidance, and implementation-oriented validation methods.
4. Invoke `math-modeling-paper` for paper structure, abstract, figures, memo/letter, citation, formatting, and final writing support after the modeling record is ready.
5. The router invokes the three independent Skills only when needed. Do not bypass `math-modeling-promax` to call a lower Skill directly. Do not merge them, reproduce their references locally, or preload their complete case/reference collections.
6. Historical award papers and case cards are structural analogues, not templates to copy and not proof that a model is universally superior.
7. Do not add another mathematical-modeling Skill unless a concrete unsolved capability gap has first been documented in the project record and the existing Skills plus orchestration rules demonstrably cannot cover it.

## Required project records

Maintain these files as the source of truth for the current competition:

- `modeling/assumptions.md`: material simplifications and their stress tests;
- `modeling/model_cards.md`: subproblem structure, candidates, baselines, and selection;
- `modeling/implementation_cards.md`: input-to-decision implementation trace;
- `modeling/validation_and_limits.md`: correctness, evidence, uncertainty, strengths, and limitations;
- `docs/workflow.md`: gate workflow, file contracts, and Skill routing.

Do not put a real competition's numerical results into the reusable examples. Replace every example record before using the project for a submission.

For formal evidence, use the Router-owned Run Ledger, Claim Ledger, Figure Contract, and Delivery Manifest under `skills/math-modeling-promax/`. A formal run must have a unique `run_id`; a paper claim must be `SUPPORTED`; a formal figure must have a completed Figure Contract; and a package-integrity pass is not a scientific or visual-quality pass.

## Gate workflow

The current stage must be explicit. A gate may be `PASS`, `PASS WITH RISK`, or `FAIL` only. `FAIL` blocks the next gate. `PASS WITH RISK` permits continuation only when the unresolved risk is recorded in `modeling/validation_and_limits.md`.

### G1 — Real-World Mechanism and Dependency Gate

Before naming algorithms, define how the real system works.

Required:

- decision or inference target for every subproblem;
- observation unit and time, space, or network resolution;
- inputs, outputs, decision variables, unknown parameters, and uncertainty;
- real-world mechanism chain;
- dependency graph between subproblems;
- explicit interfaces where one result enters another model.

`FAIL` if an algorithm appears before real quantities are defined, a model is selected only because it is advanced or popular, or a downstream interface is unspecified.

### G2 — Assumption Gate

Every material simplification must be recorded in `modeling/assumptions.md` when introduced.

Each major assumption records its ID, statement, reason, evidence or justification, dependent model/formula/component, likely bias if violated, affected output or decision, validation/stress test, and status.

`FAIL` if a major simplification has no assumption record or if its effect on a result cannot be tested or bounded.

### G3 — Candidate and Baseline Gate

For each major modeling decision, compare where appropriate:

- A — robust and interpretable baseline;
- B — competition-strength model;
- C — justified innovation option.

Compare mathematical fit, assumptions, data needs, interpretability, computational cost, implementation risk, validation difficulty, and expected decision value. Do not force A/B/C onto trivial preprocessing or deterministic bookkeeping.

`FAIL` if a complex model has no meaningful baseline, its prerequisites are missing, or its rationale is only that it is more advanced.

### G4 — Model Implementation Gate

Every selected major model requires an implementation card in `modeling/implementation_cards.md` with this trace:

`real data/input -> preprocessing -> parameter estimation -> variables/states/features -> model transformation -> training/solver -> raw output -> post-processing -> downstream decision`

The card must identify labels or targets, state transitions where applicable, parameter sources, reproducible output, and the downstream decision it supports.

`FAIL` if the implementation is only a textbook algorithm description or cannot reproduce the claimed output.

### G5 — Validation and Uncertainty Gate

Complete validation before interpreting results or drafting paper claims. At minimum select relevant checks from:

- internal correctness: dimensions, units, conservation, bounds, feasibility, convergence;
- empirical or explanatory evidence: holdout, rolling-origin, residuals, calibration, or mechanism consistency;
- baseline comparison and ablation;
- uncertainty: sensitivity, perturbation, bootstrap, scenario, robustness, or error propagation.

For every claim, state what evidence supports it and what uncertainty remains. One parameter perturbation or one fit metric is not a robustness argument.

`FAIL` if validation does not match the claim, leakage is unchecked, feasibility is not independently checked, or uncertainty is omitted where the decision depends on it.

### G6 — Strengths, Limitations, and Decision-Boundary Gate

Record strengths only with a comparator and evidence. Record each limitation with its origin, affected result, likely consequence, evidence, safe interpretation, unsafe interpretation, and concrete improvement.

`FAIL` if a limitation does not point to an affected result, a strength has no evidence, or the final recommendation exceeds what the model and data support.

### Final Mathematical-Modeling Audit

Before paper writing, every material claim must be traceable:

`real problem -> assumption -> data -> model choice -> implementation -> validation -> uncertainty -> decision -> paper claim`

The final audit also checks that:

- the global `math-modeling-promax` Skill remains the mandatory router and `AGENTS.md` remains the project-specific contract;
- the upstream Skills remain independent and are called only when needed;
- the router and the three lower Skills remain independent; no merged project-local mathematical-modeling knowledge base was created;
- no upstream knowledge base, case library, or code collection was copied into this repository;
- all placeholders and untested claims are removed or explicitly marked as reusable template fields;
- the Git diff is intentional and whitespace-clean.

## Working rules

- Start a new competition at G1. Do not jump directly to a favorite algorithm.
- Update the relevant modeling record before moving to the next gate.
- Treat missing data as an evidence-boundary issue; use scenarios only when the assumption and uncertainty are recorded.
- Keep units and interfaces explicit when forecasts feed optimization or when one subproblem feeds another.
- Do not write a paper claim, strength, limitation, or numerical result that is absent from the validated project records.
