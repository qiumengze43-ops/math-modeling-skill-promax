"""Minimal executable MILP smoke test for the solver integration."""

from __future__ import annotations

import json

import pulp


def solve_smoke_problem() -> dict[str, object]:
    problem = pulp.LpProblem("minimal_milp_smoke", pulp.LpMaximize)
    x = pulp.LpVariable("x", lowBound=0, cat=pulp.LpInteger)
    y = pulp.LpVariable("y", lowBound=0, cat=pulp.LpInteger)
    problem += 3 * x + 2 * y, "objective"
    problem += x + y <= 4, "capacity"
    status_code = problem.solve(pulp.PULP_CBC_CMD(msg=False))
    status = pulp.LpStatus[status_code]
    result = {
        "status": status,
        "objective": pulp.value(problem.objective),
        "x": x.value(),
        "y": y.value(),
        "capacity_lhs": (x.value() or 0) + (y.value() or 0),
    }
    if status != "Optimal":
        raise RuntimeError(f"MILP did not solve to Optimal: {result}")
    if result["objective"] != 12.0 or result["x"] != 4.0 or result["y"] != 0.0:
        raise AssertionError(f"Unexpected optimum: {result}")
    if result["capacity_lhs"] > 4.0:
        raise AssertionError(f"Infeasible result: {result}")
    return result


if __name__ == "__main__":
    print(json.dumps(solve_smoke_problem(), ensure_ascii=False, indent=2))
