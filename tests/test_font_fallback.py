"""Latin font fallbacks must leave CJK characters to the CJK font."""

from pathlib import Path
import subprocess
import tempfile
import unittest

from tests.test_cross_ref import ROOT


class FontFallbackTest(unittest.TestCase):
    def test_latin_font_character_coverage(self):
        with tempfile.TemporaryDirectory(prefix="font-fallback-", dir=ROOT) as tmp:
            source = Path(tmp) / "main.typ"
            source.write_text(
                '#import "/lib/template.typ": latin-font-covers\n'
                '#assert("A".match(latin-font-covers) != none)\n'
                '#assert("한".match(latin-font-covers) != none)\n'
                '#assert("中".match(latin-font-covers) == none)\n'
                '#assert("㐀".match(latin-font-covers) == none)\n'
                '#assert("豈".match(latin-font-covers) == none)\n'
                '#assert("。".match(latin-font-covers) == none)\n'
                '#assert("Ａ".match(latin-font-covers) == none)\n',
                encoding="utf-8",
            )
            result = subprocess.run(
                ["typst", "compile", str(source), str(Path(tmp) / "out.pdf"),
                 "--root", str(ROOT)],
                capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
