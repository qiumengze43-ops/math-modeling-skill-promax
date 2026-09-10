"""Regression tests for Router-owned evidence execution assets."""

from __future__ import annotations

import csv
import json
import subprocess
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path


SKILL_ROOT = Path(__file__).resolve().parents[1]


def read_csv_header(relative_path: str) -> list[str]:
    with (SKILL_ROOT / relative_path).open("r", encoding="utf-8", newline="") as stream:
        return next(csv.reader(stream))


class EvidenceTemplateTests(unittest.TestCase):
    def test_contract_templates_have_required_fields(self) -> None:
        self.assertEqual(
            read_csv_header("templates/run-ledger.csv"),
            [
                "run_id", "status", "purpose", "gate", "created_at", "code_ref",
                "command", "input_artifacts", "config_artifact", "output_artifacts",
                "seed_or_determinism", "exit_status", "feasibility_or_convergence", "notes",
            ],
        )
        self.assertEqual(
            read_csv_header("templates/claim-ledger.csv"),
            [
                "claim_id", "claim_text", "claim_type", "source_run_id",
                "derivation_reference", "output_artifact", "validation_reference",
                "uncertainty_or_limit", "owner", "state",
            ],
        )
        figure = (SKILL_ROOT / "templates/figure-contract.md").read_text("utf-8")
        self.assertIn("synthetic", figure.lower())
        manifest = json.loads((SKILL_ROOT / "templates/delivery-manifest.json").read_text("utf-8"))
        self.assertEqual(manifest["schema_version"], 1)


class RunRecordTests(unittest.TestCase):
    def setUp(self) -> None:
        self.tempdir = tempfile.TemporaryDirectory()
        self.root = Path(self.tempdir.name) / "project"
        self.root.mkdir()
        (self.root / "input.csv").write_text("x\n1\n", encoding="utf-8")
        self.ledger = self.root / "run-ledger.csv"
        self.ledger.write_text(
            (SKILL_ROOT / "templates/run-ledger.csv").read_text("utf-8"), encoding="utf-8"
        )
        self.producer = self.root / "produce.py"
        self.producer.write_text(
            "from pathlib import Path\nPath('result.json').write_text('{\\\"ok\\\": true}', encoding='utf-8')\n",
            encoding="utf-8",
        )

    def tearDown(self) -> None:
        self.tempdir.cleanup()

    def invoke(self, run_id: str = "run-001", command: list[str] | None = None, output: str = "result.json", input_path: str = "input.csv") -> subprocess.CompletedProcess[str]:
        args = [
            sys.executable, str(SKILL_ROOT / "scripts/run_record.py"),
            "--root", str(self.root), "--ledger", str(self.ledger),
            "--run-id", run_id, "--status", "FINAL", "--purpose", "fixture",
            "--gate", "G4", "--input", input_path, "--output", output, "--",
        ]
        return subprocess.run(args + (command or [sys.executable, "produce.py"]), text=True, capture_output=True)

    def test_run_record_appends_traceable_final_row(self) -> None:
        result = self.invoke()
        self.assertEqual(result.returncode, 0, result.stderr)
        with self.ledger.open("r", encoding="utf-8", newline="") as stream:
            rows = list(csv.DictReader(stream))
        self.assertEqual(len(rows), 1)
        self.assertEqual((rows[0]["run_id"], rows[0]["status"], rows[0]["exit_status"]), ("run-001", "FINAL", "0"))
        self.assertIn("result.json", rows[0]["output_artifacts"])

    def test_run_record_rejects_duplicate_id_and_root_escape(self) -> None:
        self.assertEqual(self.invoke().returncode, 0)
        duplicate = self.invoke()
        self.assertNotEqual(duplicate.returncode, 0)
        escaped = self.invoke(run_id="run-002", input_path="../outside.csv")
        self.assertNotEqual(escaped.returncode, 0)
        self.assertIn("outside project root", escaped.stderr)

    def test_run_record_rejects_failed_command_and_empty_output(self) -> None:
        failed = self.invoke(command=[sys.executable, "-c", "raise SystemExit(3)"])
        self.assertNotEqual(failed.returncode, 0)
        empty = self.invoke(run_id="run-003", command=[sys.executable, "-c", "from pathlib import Path; Path('result.json').touch()"])
        self.assertNotEqual(empty.returncode, 0)
        self.assertIn("empty output", empty.stderr)


class DeliveryCheckTests(unittest.TestCase):
    def setUp(self) -> None:
        self.tempdir = tempfile.TemporaryDirectory()
        self.root = Path(self.tempdir.name)
        self.manifest = self.root / "manifest.json"
        self.manifest.write_text(json.dumps({"schema_version": 1, "profile": "test", "required_files": ["report.pdf", "results.csv"], "optional_sha256": {}, "required_records": []}), encoding="utf-8")
        self.complete = self.root / "complete.zip"
        with zipfile.ZipFile(self.complete, "w") as archive:
            archive.writestr("report.pdf", b"pdf")
            archive.writestr("results.csv", b"x\n1\n")
        self.bad = self.root / "bad.zip"
        with zipfile.ZipFile(self.bad, "w") as archive:
            archive.writestr("../escape.txt", b"bad")
            archive.writestr("results.csv", b"")

    def tearDown(self) -> None:
        self.tempdir.cleanup()

    def invoke(self, package: Path) -> tuple[subprocess.CompletedProcess[str], dict[str, object]]:
        script = SKILL_ROOT / "scripts/delivery_check.py"
        self.assertTrue(script.is_file(), "delivery_check.py is absent")
        result = subprocess.run([sys.executable, str(script), "--root", str(self.root), "--manifest", str(self.manifest), str(package)], text=True, capture_output=True)
        return result, json.loads(result.stdout)

    def test_delivery_check_accepts_complete_safe_zip(self) -> None:
        result, report = self.invoke(self.complete)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report["status"], "PASS")

    def test_delivery_check_rejects_missing_empty_and_unsafe_members(self) -> None:
        result, report = self.invoke(self.bad)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("../escape.txt", report["unsafe_entries"])
        self.assertIn("report.pdf", report["missing_files"])
        self.assertIn("results.csv", report["empty_files"])


class RouterContractTests(unittest.TestCase):
    def test_router_requires_evidence_handoffs_without_owning_rendering(self) -> None:
        router = (SKILL_ROOT / "SKILL.md").read_text("utf-8")
        for phrase in ("Run Ledger", "Claim Ledger", "Figure Contract", "Delivery Manifest", "math-modeling-paper", "visual review"):
            self.assertIn(phrase, router)


if __name__ == "__main__":
    unittest.main()
