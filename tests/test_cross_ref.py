"""Check heading references in the rendered thesis, including user overrides."""

from pathlib import Path
import re
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
BASE_CONFIG = """title: Test
title-en: Test
author: Test
author-en: Test
id: "1"
advisor: Test
advisor-en: Test
college: Test
college-en: Test
institute: Test
institute-en: Test
degree: Test
degree-en: Test
type: Test
type-en: Test
date: 2026-01-01
oral-date: 2026-01-01
keywords: []
keywords-en: []
"""
BODY = """
#set heading(numbering: "1.1")
= Chapter <test-chapter>
== First section
== Second section <test-section>
=== Subsection <test-subsection>
Default refs: @test-chapter, @test-section, @test-subsection.
中文#ref(<test-section>)的說明。
Explicit supplement: #ref(<test-section>, supplement: [Special]).
Page ref: #ref(<test-section>, form: "page").
#figure(rect(width: 1cm, height: 1cm), caption: [Sample]) <test-figure>
Figure ref: #ref(<test-figure>).
#set heading(numbering: "A.1")
#counter(heading).update(0)
= Appendix <test-appendix>
Appendix ref: @test-appendix.
"""


class CrossRefTest(unittest.TestCase):
    def render(self, override=""):
        with tempfile.TemporaryDirectory(prefix="cross-ref-", dir=ROOT) as tmp:
            directory = Path(tmp)
            (directory / "config.yml").write_text(BASE_CONFIG + override, encoding="utf-8")
            (directory / "main.typ").write_text(
                '#import "/lib/mod.typ": load, thesis\n'
                f'#let cfg = load("/{directory.name}/config.yml")\n'
                '#show: body => thesis(cfg, body)\n' + BODY,
                encoding="utf-8",
            )
            pdf = directory / "main.pdf"
            build = subprocess.run(
                ["typst", "compile", str(directory / "main.typ"), str(pdf),
                 "--root", str(ROOT), "--font-path", str(ROOT / "fonts")],
                capture_output=True, text=True,
            )
            self.assertEqual(build.returncode, 0, build.stderr)
            rendered = subprocess.check_output(["pdftotext", "-layout", str(pdf), "-"])
            return re.sub(r"\s+", "", rendered.decode("utf-8"))

    def test_defaults_and_other_references(self):
        result = self.render()
        self.assertIn("Defaultrefs:第一章,第一章第二節,第一章第二節第一小節.", result)
        self.assertIn("中文第一章第二節的說明", result)
        self.assertIn("Explicitsupplement:Special1.2.", result)
        self.assertIn("Pageref:頁1.", result)
        self.assertIn("Figureref:圖1.1", result)
        self.assertIn("Appendixref:附錄A.", result)

    def test_custom_templates_and_numbering(self):
        result = self.render("""cross-ref:
  numbering: "1"
  chapter: "Ch {C}"
  section: "Ch {C} / Sec {S}"
  subsection: "C.S.B"
""")
        self.assertIn("Defaultrefs:Ch1,Ch1/Sec2,1.2.1.", result)


if __name__ == "__main__":
    unittest.main()
