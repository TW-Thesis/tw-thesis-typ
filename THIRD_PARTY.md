# Third-party material

The MIT license in `LICENSE` covers this project's own work: the template
code (`lib/`, `helper/`, `misc/`, `schools/`, `i18n/`, `main.typ`), the tutorial
text in `contents/`, and the sample figures in `figures/`. The files below are
not the author's and keep their own terms.

## Fonts (`fonts/`)

| Files | License | Notes |
|---|---|---|
| `fonts/english/EBGaramond/` | SIL Open Font License 1.1 (`OFL.txt` beside the files) | (c) 2017 The EB Garamond Project Authors. The four static styles were generated from the official variable fonts, because Typst does not pick a bold weight from a variable font; no glyphs were changed. |
| `fonts/english/Tinos/` | SIL Open Font License 1.1 (`OFL.txt` beside the files) | (c) 2026 The Tinos Project Authors. Metrically compatible with Times New Roman. |
| `fonts/logo/` (Buenard) | SIL Open Font License 1.1 (`OFL.txt` beside the file) | (c) The Buenard Project Authors. Used for the `#typst`-style logo macros. |
| `fonts/chinese/edukai-5.1.ttf` | Creative Commons Attribution-NoDerivs 3.0 Taiwan | TW-MOE-Std-Kai. Redistributable only unchanged and in whole, with credit to the Ministry of Education, R.O.C. |

## School material

- `docs/*.pdf` are the universities' own thesis-format regulations, fetched
  from their public websites. The copyright belongs to each school.
- `assets/watermarks/*` are university emblems. They are the property of the
  respective universities and are included only so that a thesis can carry its
  own school's watermark; the MIT license does not grant any right to them.

## Typst packages

`misc/lorem.typ` imports `@preview/kouhu` and `@preview/ipsum` at compile
time. They are downloaded by Typst, not bundled, and carry their own licenses.
