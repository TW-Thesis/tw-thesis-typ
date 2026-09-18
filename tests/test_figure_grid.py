"""Verify explicitly sized image grids and the one-row helper."""

from pathlib import Path
import subprocess
import tempfile
import unittest

from tests.test_cross_ref import ROOT


class FigureGridTest(unittest.TestCase):
    def compile(self, body):
        with tempfile.TemporaryDirectory(prefix="figure-grid-", dir=ROOT) as tmp:
            source = Path(tmp) / "main.typ"
            source.write_text('#import "/helper/figure.typ": fig-grid, fig-row\n' + body)
            return subprocess.run(
                ["typst", "compile", str(source), str(Path(tmp) / "out.pdf"),
                 "--root", str(ROOT)],
                capture_output=True, text=True,
            )

    def test_rows_columns_and_empty_cells(self):
        result = self.compile("""
#let f = fig-grid(rows: 2, columns: 3, caption: [Grid],
  ([A], [First]), ([B], [Second]), ([C], [Third]), ([D], [Fourth]))
#assert(f.body.rows.len() == 2)
#assert(f.body.children.len() == 6)
#f
#let row = fig-row(caption: [Row], [A], [B])
#assert(row.body.children.len() == 2)
#row
""")
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_too_many_images_reports_capacity(self):
        result = self.compile("""
#fig-grid(rows: 1, columns: 2, [A], [B], [C])
""")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("rows * columns", result.stderr)


if __name__ == "__main__":
    unittest.main()
