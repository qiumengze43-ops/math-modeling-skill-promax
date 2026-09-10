# Evidence Execution Contracts

Use these Router-owned contracts only when a run, claim, formal figure, or delivery package becomes formal evidence.

## Run Ledger

Create one append-only row for every recorded run. `run_id` is unique. `FINAL` describes intended use only: it does not prove mathematical validity. The row must identify the command, code reference, inputs, configuration, outputs, exit status, and feasibility or convergence evidence.

## Claim Ledger

Every material claim has a unique `claim_id`, evidence source, validation reference, uncertainty or limit, owner, and state. Only `SUPPORTED` claims with a real run ID or checkable derivation may be used as formal paper claims. `DRAFT`, `BLOCKED`, and `RETIRED` claims are not paper-ready.

## Figure Contract

Before a formal figure is rendered, record the asserted conclusion, source claims and data, target section, units, accessibility requirements, export checks, and human-review outcome. `PASS` or `PASS WITH RISK` does not replace visual review. Rendering and visual QA remain the responsibility of `math-modeling-paper`.

## Delivery Manifest

The manifest states the expected archive files, optional content hashes, and required evidence records. A passing integrity check proves only package readability and declared-file integrity; it does not establish scientific correctness or visual adequacy.
