#!/usr/bin/env python3
"""Check declared ZIP delivery integrity without extracting the archive."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import zipfile
from pathlib import Path, PurePosixPath


def is_safe_archive_name(name: str) -> bool:
    path = PurePosixPath(name)
    return bool(name) and not path.is_absolute() and ".." not in path.parts and ":" not in name


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def inspect_zip(package: Path, manifest: dict[str, object]) -> dict[str, object]:
    report: dict[str, object] = {"status": "FAIL", "checked_files": [], "missing_files": [], "empty_files": [], "unsafe_entries": [], "hash_mismatches": [], "readability_errors": []}
    try:
        with zipfile.ZipFile(package) as archive:
            names = archive.namelist()
            report["unsafe_entries"] = [name for name in names if not is_safe_archive_name(name)]
            safe_names = {name for name in names if is_safe_archive_name(name)}
            required = [str(item) for item in manifest.get("required_files", [])]
            report["missing_files"] = [name for name in required if name not in safe_names]
            empty: list[str] = []
            mismatches: list[str] = []
            checksums = manifest.get("optional_sha256", {})
            if not isinstance(checksums, dict):
                raise ValueError("optional_sha256 must be an object")
            for name in safe_names:
                data = archive.read(name)
                if not name.endswith("/") and not data:
                    empty.append(name)
                expected = checksums.get(name)
                if expected and sha256_bytes(data).lower() != str(expected).lower():
                    mismatches.append(name)
            report["checked_files"] = sorted(safe_names)
            report["empty_files"] = sorted(empty)
            report["hash_mismatches"] = sorted(mismatches)
    except (OSError, ValueError, zipfile.BadZipFile) as exc:
        report["readability_errors"] = [str(exc)]
    if not any(report[key] for key in ("missing_files", "empty_files", "unsafe_entries", "hash_mismatches", "readability_errors")):
        report["status"] = "PASS"
    return report


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", required=True, type=Path)
    parser.add_argument("--manifest", required=True)
    parser.add_argument("package")
    args = parser.parse_args(argv)
    root = args.root.resolve()
    try:
        manifest_path = (root / args.manifest).resolve() if not Path(args.manifest).is_absolute() else Path(args.manifest).resolve()
        package = (root / args.package).resolve() if not Path(args.package).is_absolute() else Path(args.package).resolve()
        if not manifest_path.is_relative_to(root) or not package.is_relative_to(root):
            raise ValueError("manifest or package outside project root")
        report = inspect_zip(package, json.loads(manifest_path.read_text("utf-8")))
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        report = {"status": "FAIL", "checked_files": [], "missing_files": [], "empty_files": [], "unsafe_entries": [], "hash_mismatches": [], "readability_errors": [str(exc)]}
    print(json.dumps(report, ensure_ascii=False))
    return int(report["status"] != "PASS")


if __name__ == "__main__":
    raise SystemExit(main())
