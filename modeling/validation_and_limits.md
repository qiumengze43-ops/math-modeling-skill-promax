# Validation, Uncertainty, Strengths, and Limitations

Validation records are written before final interpretation. A claim cannot be upgraded from a placeholder by prose alone.

## Validation Matrix

| Claim / result | Internal correctness | Empirical evidence | Baseline / ablation | Uncertainty test | Status |
|---|---|---|---|---|---|
| <claim> | <check> | <evidence> | <comparator> | <test> | UNTESTED |

Status values:

- `UNTESTED`
- `PARTIAL`
- `SUPPORTED`
- `WEAK`
- `REJECTED`

## Assumption–Result–Limitation Matrix

| Assumption ID | Model | Affected result | Failure direction | Test | Observed impact | Final limitation |
|---|---|---|---|---|---|---|
| <A-ID> | <model> | <result> | <direction> | <test> | <impact> | <limitation> |

## Strength Records

### S-001 — <strength>

**Compared with**

<baseline>

**What weakness is improved**

<specific weakness>

**Evidence**

<metric, robustness, feasibility, or interpretability evidence>

**Decision value**

<why this matters to the real decision>

## Limitation Records

### L-001 — <limitation>

**Origin**

- assumption:
- modeling choice:
- data limitation:
- implementation limitation:

**Affected result**

<result>

**Likely consequence**

<direction, range, uncertainty, or failure mode>

**Evidence**

<test>

**What the model can still support**

<safe interpretation>

**What the model cannot support**

<unsafe interpretation>

**Possible future improvement**

<concrete improvement only>

## Example Records

> EXAMPLE ONLY — DELETE OR REPLACE FOR A REAL COMPETITION.

### S-EX1 — Explicit transaction uncertainty

**Compared with**

A deterministic transaction-feasibility baseline.

**What weakness is improved**

The recommendation no longer treats every feasible transaction as certain to execute.

**Evidence**

Compare objective value, selected transactions, and feasibility across success-rate scenarios 1.0, 0.7, and 0.4.

**Decision value**

The decision maker can see how much the roster recommendation depends on execution risk.

### L-EX1 — Counterparty behavior is simplified

**Origin**

- assumption: A-EX1;
- modeling choice: exogenous success-rate scenarios;
- data limitation: no observed counterparty response history;
- implementation limitation: no multi-agent negotiation model.

**Affected result**

Selected transactions and objective value.

**Likely consequence**

The recommendation may be optimistic if success rates are overestimated.

**Evidence**

Stress test at success rates 1.0, 0.7, and 0.4.

**What the model can still support**

Scenario-based roster comparison under stated execution assumptions.

**What the model cannot support**

A claim that the recommended transaction will occur with certainty.

**Possible future improvement**

Calibrate success probabilities from historical transaction outcomes and model counterparties explicitly.

## Paper Extraction Rules

- Assumptions come from `assumptions.md`.
- Model selection comes from `model_cards.md`.
- Implementation descriptions come from `implementation_cards.md`.
- Validation comes from the Validation Matrix.
- Strengths and limitations come from tested records.
- Do not invent an assumption, validation result, numerical result, or limitation during final writing. Update the ledger first and re-check downstream effects.
