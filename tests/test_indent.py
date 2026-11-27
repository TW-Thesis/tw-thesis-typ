"""Paragraphs after headings, figures and code should retain the thesis indent."""

from pathlib import Path
import re
import subprocess
import tempfile
import unittest

from tests.test_cross_ref import BASE_CONFIG, ROOT


BODY = """
#set heading(numbering: "1.1")
= Heading
FIRSTAFTERHEADING text.

SECONDPARAGRAPH text.

#figure(rect(width: 1cm, height: 1cm), caption: [Figure])

AFTERFIGURE text.

#figure(table(columns: 1, [Cell]), caption: [Table], kind: table)

AFTERTABLE text.

#figure(raw("code", block: true), caption: [Code], kind: "code", supplement: [程式碼])

AFTERCODEFIGURE text.

```typ
standalone code
```

AFTERRAWCODE text.
"""


class IndentTest(unittest.TestCase):
    def positions(self, override=""):
        with tempfile.TemporaryDirectory(prefix="indent-", dir=ROOT) as tmp:
            directory = Path(tmp)
            (directory / "config.yml").write_text(BASE_CONFIG + override, encoding="utf-8")
            (directory / "main.typ").write_text(
                '#import "/lib/mod.typ": load, thesis\n'
                '#import "/helper/code.typ": code-style\n'
                f'#let cfg = load("/{directory.name}/config.yml")\n'
                '#show: body => thesis(cfg, code-style(body))\n' + BODY,
                encoding="utf-8",
            )
            pdf = directory / "main.pdf"
            build = subprocess.run(
                ["typst", "compile", str(directory / "main.typ"), str(pdf),
                 "--root", str(ROOT), "--font-path", str(ROOT / "fonts")],
                capture_output=True, text=True,
            )
            self.assertEqual(build.returncode, 0, build.stderr)
            xml = subprocess.check_output(
                ["pdftohtml", "-xml", "-stdout", str(pdf)], stderr=subprocess.DEVNULL
            ).decode("utf-8")
            return {
                word: int(left)
                for left, word in re.findall(r'<text[^>]*left="(\d+)"[^>]*>([A-Z]+)', xml)
            }

    def test_every_paragraph_indents_by_default(self):
        positions = self.positions()
        for word in ("FIRSTAFTERHEADING", "AFTERFIGURE", "AFTERTABLE", "AFTERCODEFIGURE", "AFTERRAWCODE"):
            self.assertEqual(positions[word], positions["SECONDPARAGRAPH"], word)

    def test_heading_following_paragraph_is_flush_when_indent_all_is_off(self):
        positions = self.positions("layout:\n  first-line-indent-all: false\n")
        self.assertLess(positions["FIRSTAFTERHEADING"], positions["SECONDPARAGRAPH"])
        for word in ("AFTERFIGURE", "AFTERTABLE", "AFTERCODEFIGURE", "AFTERRAWCODE"):
            self.assertEqual(positions[word], positions["SECONDPARAGRAPH"], word)

    def test_zero_indent_indents_nothing(self):
        positions = self.positions("layout:\n  first-line-indent: 0\n")
        self.assertEqual(positions["FIRSTAFTERHEADING"], positions["SECONDPARAGRAPH"])


if __name__ == "__main__":
    unittest.main()
