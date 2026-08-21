# Full Dry Run — 2023 CUMCM C

> FULL DRY RUN ONLY — this document validates the project workflow against public old-question data. It is not a contest solution and contains no copied award answer.

## Source and input boundary

The public repository `JiananXie/CUMCM-2023-Problem-C` provides the 2023 CUMCM C problem and its four attachments. This run used the original public `附件1.xlsx` product-category table and `附件2.xlsx` sales table. The files were downloaded to a temporary directory and are not committed to this repository.

The extraction script reads:

- `附件1.xlsx`: `单品编码` → `分类名称`;
- `附件2.xlsx`: `销售日期`, `单品编码`, and `销量(千克)`.

It produced a temporary daily category sales table with 878,503 sales rows, 878,503 matched rows, 1,085 days, and six categories.

## Reproducible commands

With `openpyxl` available in the active Python environment:

```powershell
python scripts/extract_cumcm2023c_sales.py `
  --attachment1 <temporary-data>\附件1.xlsx `
  --attachment2 <temporary-data>\附件2.xlsx `
  --output <temporary-data>\sales_by_category_from_attachments.csv

python scripts/full_dry_run.py `
  --sales-csv <temporary-data>\sales_by_category_from_attachments.csv `
  --category 花叶类 `
  --test-days 14 `
  --output-json <temporary-data>\full-dry-run.json
```

## Gate execution

### G1 — Real-world mechanism and dependency

**Status: PASS WITH RISK**

```text
raw sales attachment
  → item-to-category join
  → daily category demand
  → time-ordered demand forecast
  → next-day replenishment quantity
  → stockout and waste validation
```

The actual interface is `daily category sales → forecast quantity → replenishment scenario`. Pricing, wholesale cost, shelf capacity, and cross-category substitution remain outside this reduced dry-run scope.

### G2 — Assumption

**Status: PASS WITH RISK**

The dry run assumes that daily demand can be forecast at category level and that a forecast quantity can serve as a replenishment scenario. It does not interpret observational price-sales pairs as causal price elasticity.

### G3 — Candidate and baseline

**Status: PASS**

- A — mean baseline: the mean of all training-period daily demand;
- B — linear-trend candidate: ordinary least-squares trend on the training period;
- selected model: chosen by lower time-ordered holdout MAE.

The run selected the baseline because its holdout error was lower.

### G4 — Implementation

**Status: PASS**

```text
附件1/附件2
  → openpyxl streaming read and item-category join
  → daily category aggregation
  → chronological train/test split
  → mean baseline and linear-trend candidate
  → holdout MAE comparison
  → selected forecast as next-day replenishment quantity
  → stockout/waste accounting
```

The selected model, raw output, and downstream decision are all explicit. No paper result is inferred from this dry run.

## Actual validation result

Category: `花叶类`; date range: `2020-07-01` to `2023-06-30`; 1,071 training records and 14 time-ordered test records.

| Metric | Mean baseline | Linear-trend candidate | Selected result |
|---|---:|---:|---:|
| Holdout MAE (kg) | 51.856216 | 53.124892 | mean baseline |
| Next-day replenishment (kg) | 183.396303 | — | 183.396303 |
| Test stockout (kg) | 130.988395 | — | 130.988395 |
| Test waste (kg) | 594.998630 | — | 594.998630 |

### G5 — Validation and uncertainty

**Status: PASS WITH RISK**

Completed checks:

- chronological holdout rather than random leakage-prone splitting;
- baseline versus candidate MAE comparison;
- nonnegative forecast and replenishment quantity;
- independent stockout and waste accounting.

Remaining uncertainty is material: a single holdout window does not establish seasonal robustness. A real competition run should add rolling-origin evaluation, perturbation/scenario tests, and cost/price uncertainty before making a profit claim.

### G6 — Strengths, limitations, and decision boundary

**Status: PASS WITH RISK**

Strength supported by this run: the workflow can reject a more complex candidate when a transparent baseline performs better on held-out data.

Limitation supported by this run: the result is a category-demand replenishment scenario only. It cannot support causal price-elasticity, profit-maximization, shelf-capacity, spoilage-cost, or cross-category-substitution claims because those inputs were not modeled.

## Audit chain

```text
real attachments
  → explicit category-level assumption
  → baseline and candidate comparison
  → extraction and forecast implementation
  → time-ordered validation
  → stockout/waste evidence
  → bounded limitation
```

This closes the requested `Assumption → Model → Implementation → Validation → Limitation` execution chain without claiming that the complete 2023 contest problem has been solved.
