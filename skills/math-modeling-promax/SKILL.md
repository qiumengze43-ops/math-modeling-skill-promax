---
name: math-modeling-promax
description: Route mathematical-modeling work through the Promax workflow and select the appropriate independent upstream Skills for mechanism analysis, solving, validation, and paper writing.
---

# Math Modeling Promax Router

This is the global orchestration Skill for the Promax mathematical-modeling workflow. It is a router, not a replacement for the three independent domain Skills below:

- `math-modeling-skill`: real-world mechanism, evidence boundary, candidate models, assumptions, and modeling audit.
- `math-modeling-solver`: detailed methods, algorithms, implementation, code scaffolds, and solver-oriented validation.
- `math-modeling-paper`: paper structure, abstract, figures, citations, formatting, and final writing review.

## Mandatory routing rule

对于数学建模任务，必须先通过 `math-modeling-promax` 识别当前阶段、目标产物和所需证据，再路由到一个或多个下层 Skill。不得绕过路由器直接调用下层 Skill。下层 Skill 仍然保持独立，不得把它们的知识库合并成一个 Skill。
If a project-local `AGENTS.md` is present, follow its more specific gate and file contracts. If it is absent, this global router still works; keep reasoning and claims scoped to the current workspace and do not assume that the Promax repository exists.

ROUTE_REQUIRED: All downstream Skills must be selected by this router first.
NO_DIRECT_DOWNSTREAM_CALLS: Direct invocation of math-modeling-skill, math-modeling-solver, or math-modeling-paper without this router is prohibited.

## Stage routing

1. Start at G1: define the real-world mechanism, observation unit, inputs/outputs, uncertainty, dependency graph, and interfaces before naming an algorithm.
2. Route G1, G2, G3, and G6 work to `math-modeling-skill`.
3. Route implementation, algorithm selection details, executable code, and G4 work to `math-modeling-solver`, after the mechanism and candidate-model gate is explicit.
4. Route validation and uncertainty (G5) to `math-modeling-skill` for evidence boundaries and to `math-modeling-solver` for executable checks, as needed.
5. Route paper drafting, figures, abstracts, citations, formatting, and final paper audit to `math-modeling-paper`, only after the modeling record and validation evidence are ready.
6. When a task crosses stages, keep the dependency order `mechanism -> assumptions -> candidates/baseline -> implementation -> validation/uncertainty -> decision -> paper claim` and invoke the lower Skills through this router.

## Required handoff discipline

Before each handoff, state:

- the current gate and the concrete decision or artifact being produced;
- the inputs and evidence boundary available to the next Skill;
- the expected output and its downstream consumer;
- unresolved assumptions, risks, and validation obligations.

Do not present a model name, numerical result, strength, limitation, or paper claim as established unless the routed workflow has recorded its assumptions, implementation trace, validation evidence, and uncertainty. Historical cases are structural analogues, not proof of universal superiority.

When the current workspace contains the Promax records, update the relevant `modeling/*.md` file before advancing a gate. Otherwise, preserve the same trace in the current project's own records.


