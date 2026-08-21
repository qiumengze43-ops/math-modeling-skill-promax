"""Run a small, reproducible forecast-to-replenishment dry run."""

from __future__ import annotations

import argparse
import csv
import json
import math
from datetime import date
from pathlib import Path
from statistics import mean
from typing import Iterable


def _read_series(path: Path, category: str) -> list[tuple[date, float]]:
    with path.open("r", newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if not reader.fieldnames or "销售日期" not in reader.fieldnames or category not in reader.fieldnames:
            raise ValueError(f"CSV must contain 销售日期 and {category!r}; found {reader.fieldnames}")
        values = []
        for row in reader:
            values.append((date.fromisoformat(row["销售日期"]), float(row[category])))
    values.sort()
    if len(values) < 10:
        raise ValueError("At least 10 daily observations are required")
    return values


def _linear_fit(values: list[float]) -> tuple[float, float]:
    n = len(values)
    x_mean = (n - 1) / 2
    y_mean = mean(values)
    denominator = sum((index - x_mean) ** 2 for index in range(n))
    slope = 0.0 if denominator == 0 else sum((index - x_mean) * (value - y_mean) for index, value in enumerate(values)) / denominator
    return y_mean - slope * x_mean, slope


def _mae(actual: Iterable[float], predicted: Iterable[float]) -> float:
    pairs = list(zip(actual, predicted))
    return sum(abs(left - right) for left, right in pairs) / len(pairs)


def _stockout_and_waste(actual: Iterable[float], order: Iterable[float]) -> tuple[float, float]:
    stockout = 0.0
    waste = 0.0
    for observed, planned in zip(actual, order):
        stockout += max(observed - planned, 0.0)
        waste += max(planned - observed, 0.0)
    return stockout, waste


def run_dry_run(path: Path, category: str, test_days: int = 14) -> dict[str, object]:
    series = _read_series(path, category)
    if test_days <= 0 or test_days >= len(series) - 5:
        raise ValueError("test_days must leave at least six training observations")
    split = len(series) - test_days
    train = [value for _, value in series[:split]]
    actual = [value for _, value in series[split:]]
    baseline_forecast = [mean(train)] * test_days
    intercept, slope = _linear_fit(train)
    trend_forecast = [max(0.0, intercept + slope * (split + offset)) for offset in range(test_days)]
    baseline_mae = _mae(actual, baseline_forecast)
    trend_mae = _mae(actual, trend_forecast)
    selected_model = "linear-trend" if trend_mae < baseline_mae else "mean-baseline"
    selected_forecast = trend_forecast if selected_model == "linear-trend" else baseline_forecast
    stockout, waste = _stockout_and_waste(actual, selected_forecast)
    return {
        "problem": "2023 CUMCM C — vegetable pricing and replenishment",
        "category": category,
        "records": len(series),
        "train_records": len(train),
        "test_records": len(actual),
        "date_range": [series[0][0].isoformat(), series[-1][0].isoformat()],
        "baseline_model": "mean-baseline",
        "candidate_model": "linear-trend",
        "baseline_mae": round(baseline_mae, 6),
        "candidate_mae": round(trend_mae, 6),
        "selected_model": selected_model,
        "selected_mae": round(_mae(actual, selected_forecast), 6),
        "next_day_replenishment_kg": round(selected_forecast[-1], 6),
        "stockout_kg": round(stockout, 6),
        "waste_kg": round(waste, 6),
        "assumption": "Daily category demand is forecast at the category level; the recommendation is a quantity scenario, not a causal price-elasticity claim.",
        "validation": ["time-ordered holdout", "baseline comparison", "stockout and waste accounting"],
        "limitation": "The dry run does not model wholesale price, discounts, shelf capacity, or cross-category substitution.",
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sales-csv", type=Path, required=True)
    parser.add_argument("--category", default="花叶类")
    parser.add_argument("--test-days", type=int, default=14)
    parser.add_argument("--output-json", type=Path)
    args = parser.parse_args()
    result = run_dry_run(args.sales_csv, args.category, args.test_days)
    rendered = json.dumps(result, ensure_ascii=False, indent=2)
    print(rendered)
    if args.output_json:
        args.output_json.parent.mkdir(parents=True, exist_ok=True)
        args.output_json.write_text(rendered + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
