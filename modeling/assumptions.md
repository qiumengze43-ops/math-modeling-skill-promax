# Assumption Ledger

This ledger is maintained during modeling. Every material simplification gets one record before it is used in a model, formula, code path, or decision.

## Status

- `PROPOSED`: identified but not yet justified or tested;
- `ACTIVE`: justified for the current scope and linked to a test;
- `STRESSED`: tested under a perturbation or alternative scenario;
- `REJECTED`: not safe for the current problem;
- `RETIRED`: no longer used after a model or scope change.

## Assumption Template

### A-001 — <short name>

**Statement**

<one falsifiable statement about the real system or data>

**Why needed**

<what would become infeasible, unidentified, or outside scope without it>

**Evidence / justification**

<problem text, data check, domain source, or explicit scope decision>

**Used by**

- model:
- formula/component:
- downstream task or decision:

**If violated**

- likely bias or failure direction:
- affected output:
- affected decision:

**Validation / stress test**

<specific perturbation, subgroup check, alternative scenario, or falsification test>

**Status**

PROPOSED

## Example Record

> EXAMPLE ONLY — DELETE OR REPLACE FOR A REAL COMPETITION.

### A-EX1 — External transaction availability

**Statement**

Transactions satisfying financial and value constraints are executable with a scenario-dependent success probability.

**Why needed**

Explicitly modeling all counterparties would turn the problem into a multi-agent negotiation model outside the supplied scope.

**Evidence / justification**

This is a scope reduction, not a claim of perfect liquidity.

**Used by**

- model: roster optimization;
- formula/component: transaction feasibility;
- downstream task or decision: recommended roster.

**If violated**

- likely bias or failure direction: optimistic;
- affected output: objective value and selected transactions;
- affected decision: roster recommendation.

**Validation / stress test**

Re-run at success rates 1.0, 0.7, and 0.4 and report changes in selected transactions and objective value.

**Status**

ACTIVE

## Assumption Review Checklist

- [ ] The assumption states a material simplification, not a vague confidence statement.
- [ ] The reason is tied to scope, identification, data, or computational feasibility.
- [ ] A model component and downstream result are named.
- [ ] A violation direction or failure mode is stated.
- [ ] A test, perturbation, or scenario is specified.
- [ ] Status is current and consistent with validation evidence.
- [ ] New assumptions are added here before paper drafting.
