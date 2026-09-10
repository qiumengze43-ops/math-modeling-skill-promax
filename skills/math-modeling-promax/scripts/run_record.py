#!/usr/bin/env python3
"""Append one traceable, successful execution row to a Promax Run Ledger."""

from __future__ import annotations

import argparse
import csv
import subprocess
import sys
from datetime import UTC, datetime
from pathlib import Path


RUN_HEADER = [
    "run_id", "status", "purpose", "gate", "created_at", "code_ref",
    "command", "input_artifacts", "config_artifact", "output_artifacts",
    "seed_or_determinism", "exit_status", "feasibility_or_convergence", "notes",
]


def resolve_project_path(root: Path, raw: str) -> Path:
    """Resolve *raw* and reject paths outside the declared project root."""
    path = (root / raw).resolve() if not Path(raw).is_absolute() else Path(raw).resolve()
    if not path.is_relative_to(root):
        raise ValueError(f"path outside project root: {raw}")
    return path


def verify_nonempty_file(path: Path, label: str) -> None:
    """Require a regular, nonempty artifact at *path*."""
    if not path.is_file():
        raise ValueError(f"missing {label}: {path}")
    if path.stat().st_size == 0:
        raise ValueError(f"empty {label}: {path}")


def ledger_has_run_id(ledger: Path, run_id: str) -> bool:
    """Return whether an existing ledger row already owns *run_id*."""
    with ledger.open("r", encoding="utf-8", newline="") as stream:
        return any(row.get("run_id") == run_id for row in csv.DictReader(stream))


def append_row(ledger: Path, row: dict[str, str]) -> None:
    """Append exactly one row without rewriting prior records."""
    with ledger.open("a", encoding="utf-8", newline="") as stream:
        csv.DictWriter(stream, fieldnames=RUN_HEADER).writerow(row)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", required=True, type=Path)
    parser.add_argument("--ledger", required=True)
    parser.add_argument("--run-id", required=True)
    parser.add_argument("--status", required=True, choices=("EXPLORATORY", "VALIDATION", "FINAL"))
    parser.add_argument("--purpose", required=True)
    parser.add_argument("--gate", required=True)
    parser.add_argument("--code-ref", default="unrecorded")
    parser.add_argument("--input", action="append", required=True, dest="inputs")
    parser.add_argument("--config")
    parser.add_argument("--output", action="append", required=True, dest="outputs")
    parser.add_argument("--seed", default="not specified")
    parser.add_argument("--feasibility-or-convergence", default="not recorded")
    parser.add_argument("--notes", default="")
    parser.add_argument("command", nargs=argparse.REMAINDER)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        root = args.root.resolve()
        if not root.is_dir():
            raise ValueError(f"project root is not a directory: {root}")
        ledger = resolve_project_path(root, args.ledger)
        if not ledger.is_file():
            raise ValueError(f"missing ledger: {ledger}")
        with ledger.open("r", encoding="utf-8", newline="") as stream:
            if csv.reader(stream).__next__() != RUN_HEADER:
                raise ValueError(f"invalid Run Ledger header: {ledger}")
        if ledger_has_run_id(ledger, args.run_id):
            raise ValueError(f"duplicate run_id: {args.run_id}")
        inputs = [resolve_project_path(root, raw) for raw in args.inputs]
        outputs = [resolve_project_path(root, raw) for raw in args.outputs]
        for path in inputs:
            verify_nonempty_file(path, "input")
        config = ""
        if args.config:
            config_path = resolve_project_path(root, args.config)
            verify_nonempty_file(config_path, "config")
            config = str(config_path.relative_to(root))
        command = args.command[1:] if args.command[:1] == ["--"] else args.command
        if not command:
            raise ValueError("missing command after --")
        completed = subprocess.run(command, cwd=root, check=False)
        if completed.returncode != 0:
            raise ValueError(f"command exited with status {completed.returncode}")
        for path in outputs:
            verify_nonempty_file(path, "output")
        append_row(ledger, {
            "run_id": args.run_id,
            "status": args.status,
            "purpose": args.purpose,
            "gate": args.gate,
            "created_at": datetime.now(UTC).isoformat(),
            "code_ref": args.code_ref,
            "command": " ".join(command),
            "input_artifacts": ";".join(str(path.relative_to(root)) for path in inputs),
            "config_artifact": config,
            "output_artifacts": ";".join(str(path.relative_to(root)) for path in outputs),
            "seed_or_determinism": args.seed,
            "exit_status": "0",
            "feasibility_or_convergence": args.feasibility_or_convergence,
            "notes": args.notes,
        })
        return 0
    except (OSError, ValueError, csv.Error) as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
