import csv
import tempfile
import unittest
from pathlib import Path

from full_dry_run import run_dry_run


class FullDryRunTests(unittest.TestCase):
    def test_runs_baseline_selected_model_and_validation(self):
        rows = [(f"2024-01-{day:02d}", 10 + day) for day in range(1, 15)]
        with tempfile.TemporaryDirectory() as temp_dir:
            path = Path(temp_dir) / "sales.csv"
            with path.open("w", newline="", encoding="utf-8-sig") as handle:
                writer = csv.writer(handle)
                writer.writerow(["销售日期", "花叶类"])
                writer.writerows(rows)
            result = run_dry_run(path, "花叶类", test_days=4)

        self.assertEqual(result["records"], 14)
        self.assertIn(result["selected_model"], {"mean-baseline", "linear-trend"})
        self.assertIn("baseline_mae", result)
        self.assertIn("selected_mae", result)
        self.assertIn("stockout_kg", result)
        self.assertIn("waste_kg", result)
        self.assertGreaterEqual(result["selected_mae"], 0)


if __name__ == "__main__":
    unittest.main()
