# Dry Run — 2023 CUMCM C

> DRY RUN ONLY — this document tests the project workflow and is not a contest solution. Do not copy it into a submission.

## Scope

Selected public old problem: 2023 CUMCM Problem C, “Automatic Pricing and Replenishment Decisions of Vegetable Products”. The public statement describes historical sales, wholesale prices, product information, and loss-rate data, and asks for sales relationships plus a one-week pricing and replenishment decision. This dry run uses the statement structure only; it does not reproduce an award paper or claim numerical results.

## Gate results

### G1 — Real-world mechanism and dependency

**Status: PASS WITH RISK**

Mechanism chain:

```text
historical sales and prices
  → demand / price-response evidence
  → next-day demand and cost scenarios
  → category-level replenishment and pricing decision
  → revenue, waste, and feasibility assessment
```

Subproblem interfaces:

- P1 describes category and item sales distributions and cross-category/item relationships.
- P2 uses demand and cost relationships to produce the next-week category pricing and replenishment policy.
- P3 extends the policy to item-level or more detailed decisions when the data support the interface.
- P4 identifies additional data that would reduce decision uncertainty; it is not allowed to silently become a new fitted model.

Risk: the exact aggregation unit, discount treatment, and meaning of “sold out” must be confirmed from the attachments before implementation.

### G2 — Assumption

**Status: PASS WITH RISK**

Candidate assumptions to register before implementation:

- daily category demand can be represented at the selected aggregation resolution;
- unsold fresh goods have a documented loss or salvage treatment;
- observed price and sales pairs are not automatically causal price elasticity evidence;
- future wholesale cost and demand must be represented as scenarios or forecasts with uncertainty;
- the replenishment decision is feasible under ordering, shelf-life, and availability constraints.

The dry run caught that “use average wholesale price as cost” would be a material simplification and must not be introduced without an assumption ID and sensitivity test.

### G3 — Candidate and baseline

**Status: PASS WITH RISK**

For the forecast-to-decision interface:

- A — robust baseline: seasonal or rolling historical demand baseline plus a transparent price-response model;
- B — competition-strength: forecast distribution or calibrated regression feeding a constrained rolling-horizon optimization;
- C — innovation option: uncertainty-aware robust or stochastic optimization with waste and stockout risk terms.

Selection is deliberately deferred until the attachments establish sample size, missingness, price variation, and whether the uncertainty model is identifiable. The baseline remains mandatory even if B or C is later selected.

### G4 — Implementation

**Status: PASS WITH RISK**

Required trace before code:

```text
sales / price / wholesale / loss-rate files
  → date-item-category join and data-quality checks
  → demand, cost, loss, and price-response parameter estimates
  → category-day decision variables and forecast states
  → demand/cost transformation and replenishment constraints
  → baseline forecast plus constrained solver
  → price, order quantity, expected sales, waste, profit, and risk
  → unit conversion and scenario summary
  → daily pricing and replenishment recommendation
```

The interface that must be tested is `forecast distribution → decision model`; a point forecast alone is not sufficient when stockout and waste change the decision.

### G5 — Validation and uncertainty

**Status: PASS WITH RISK**

No numerical claim is made because the old-question attachments are not in this project. The required validation plan is:

- internal: join keys, units, nonnegative quantities, price bounds, order bounds, and independent feasibility checks;
- empirical: time-ordered holdout or rolling-origin evaluation for demand and cost;
- comparative: baseline versus selected model, plus ablation of price-response and uncertainty terms;
- uncertainty: demand/cost perturbations, loss-rate scenarios, and forecast-error propagation into the decision;
- decision: report profit, waste, stockout, and feasibility together rather than profit alone.

### G6 — Strengths and limitations

**Status: PASS WITH RISK**

Safe strength candidate: the workflow explicitly keeps the forecast-to-decision interface and tests it against a baseline.

Safe limitation candidate: observational price and sales data alone may not identify causal price elasticity; the model can support scenario-based planning under stated assumptions, not a universal causal pricing claim.

Both records require actual data tests before they can become `SUPPORTED` paper claims.

## Failure modes caught

1. Naming Prophet, XGBoost, genetic algorithms, or another favorite method before defining the demand-cost-decision mechanism.
2. Treating average cost as ground truth without an assumption record.
3. Sending a point forecast into an optimization model without an uncertainty interface.
4. Reporting profit without waste, stockout, feasibility, or baseline comparison.
5. Turning the additional-data question into an unvalidated model extension.

## Minimum correction

The project-local correction is already represented in `AGENTS.md` and the modeling templates: G1 defines the interface, G2 records average-cost and causal-interpretation assumptions, G3 retains a transparent baseline, G4 requires the forecast-to-decision trace, and G5 blocks unsupported numerical interpretation.
