# Model Implementation Cards

Each selected major model must be traceable from real input to downstream decision. Fill a card before formal implementation or paper claims.

## Implementation Card Template

### M-001 — <model name>

**Linked subproblem and model card**

- subproblem:
- selected candidate:
- baseline comparator:

**Real data / input schema**

<file, table, field, unit, observation unit, time/space resolution>

**Preprocessing**

<missing values, outliers, normalization, feature construction, leakage prevention, and reason for each>

**Parameter estimation / source**

<calibration data, fitted parameters, external source, prior, or fixed value and its justification>

**Variables, states, and features**

<definitions, units, allowed ranges, labels/targets, and state at one time step>

**Model transformation**

<problem-specific equations, objective, constraints, transition, or likelihood>

**Training / solver**

<algorithm, solver, initialization, stopping rule, random seed, and feasibility/convergence check>

**Raw output**

<predictions, parameter estimates, feasible solution, policy, ranking, or simulation samples>

**Post-processing**

<unit conversion, bounds, calibration, uncertainty summary, ranking, or scenario aggregation>

**Downstream decision**

<how the output changes a real recommendation or enters the next subproblem>

**Reproducibility and failure checks**

<configuration, assertions, saved artifacts, and known failure conditions>

## Required Trace

`real data/input -> preprocessing -> parameter estimation -> variables/states/features -> model transformation -> training/solver -> raw output -> post-processing -> downstream decision`

## Algorithm-Specific Audit Questions

### ML / Deep Learning

- What is the target or label?
- How are samples constructed?
- What are the train, validation, and test splits?
- What prevents leakage?
- What baseline is retained?
- Which metric matches the real claim?

### Reinforcement Learning

- What is one state, action, time step, and episode?
- How is the environment transition generated?
- Which transition parameters are calibrated from real data?
- What baseline policy is used?
- Is performance stable across seeds and scenarios?

### Optimization

- What are the decision variables and units?
- Which constraints are hard or soft?
- Are units and scales consistent?
- Is feasibility checked independently?
- Is the solver exact, approximate, or heuristic?
- Does parameter uncertainty change the recommended decision?

### Graph / GNN

- What is a node, edge, target, and ground truth?
- How are graph samples constructed?
- Why is a graph model necessary versus an additive or tabular baseline?

### Simulation

- What mechanisms or distributions generate randomness?
- How are parameters calibrated?
- How many repetitions are required for stable estimates?
- What uncertainty or confidence summary is reported?

## Example Trace

> EXAMPLE ONLY — DELETE OR REPLACE FOR A REAL COMPETITION.

`current state -> candidate action -> simulated outcome -> revenue/cost update -> next state -> re-optimize`

The example is only a trace shape. A real card must fill the input schema, transition parameters, solver, output artifact, and decision interface.
