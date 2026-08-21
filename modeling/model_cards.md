# Model Cards

Model cards describe why a model is needed, what it consumes, what it returns, and why it was selected. They are not generic algorithm summaries.

## Subproblem Template

### P-01 — <subproblem>

**Decision / inference target**

<what must be estimated, ranked, explained, simulated, or decided>

**Observation unit and resolution**

<row/entity/time/space/network unit and granularity>

**Inputs and outputs**

- inputs:
- output:
- uncertainty:

**Real-world mechanism**

<mechanism chain before model names>

**Dependencies and interface**

- upstream result:
- transformation into this model:
- downstream consumer:

## Candidate A — Robust Baseline

**Model and formulation**

<interpretable model or deterministic rule>

**Assumptions and data needs**

<minimum assumptions and required fields>

**Validation plan**

<correctness, empirical, comparison, and uncertainty checks>

## Candidate B — Competition-Strength

**Model and formulation**

<model that addresses a material weakness of A>

**Added value and prerequisites**

<what relationship, constraint, or uncertainty is represented and what data it needs>

## Candidate C — Innovation Option

**Model and formulation**

<justified innovation in abstraction, feature, constraint, uncertainty, or solver>

**Ablation and failure risk**

<what would prove the added component is not useful>

## Comparison

| Criterion | A — baseline | B — competition-strength | C — innovation |
|---|---|---|---|
| Mathematical fit |  |  |  |
| Assumptions |  |  |  |
| Data requirements |  |  |  |
| Interpretability |  |  |  |
| Computational cost |  |  |  |
| Implementation risk |  |  |  |
| Validation difficulty |  |  |  |
| Expected decision value |  |  |  |

## Selection

**Selected candidate**

<A, B, or C>

**Selection rationale**

<evidence-regime-specific reason; never only “more advanced”>

**Baseline retained for comparison**

<baseline and exact comparator>

**Prerequisites and gate status**

<data, assumptions, implementation card, validation requirements>

## Blocking Rules

- A complex model without a meaningful baseline is blocked.
- A model whose prerequisites are absent is blocked.
- A model selected only because it is advanced or popular is blocked.
- A model feeding another model without an explicit interface is blocked.
- A model with unclear target, state, parameter source, or decision output cannot pass G4.
- A result with no claim-matched validation cannot pass G5.

## Example Card

> EXAMPLE ONLY — DELETE OR REPLACE FOR A REAL COMPETITION.

For a rolling resource-allocation problem, compare:

- A: static weighted optimization;
- B: rolling-horizon or model-predictive optimization;
- C: reinforcement-learning-controlled optimization.

C is not retained because it is “advanced”. It is retained only if validation shows a stable, interpretable, and decision-relevant improvement over B across seeds and scenarios.
