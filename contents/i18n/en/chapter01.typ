#import "/helper/mod.typ": *

= Getting Started

Before you start, keep the sample files as they are and compile once following the steps in this chapter, to confirm you can produce a PDF and that the CJK font and page layout render correctly. Once that works, fill in your own thesis details and replace the titles and body text chapter by chapter. It's best to recompile after each change you make -- if an error shows up, it's much easier to tell which edit caused it.

The source files for this tutorial live in `contents/`, and each chapter corresponds to the matching chapter in the compiled PDF. When you see a figure, citation, or code block you want to use, open the corresponding chapter, copy the example, and swap in your own text and data. If you come across syntax you don't recognize yet, leave it as-is for now, compare it against the compiled output, and adjust piece by piece -- once you understand the effect, apply it to the other chapters.

== Installation and Compilation

Before you can compile and write, you need to install #link("https://typst.app/open-source/")[#typst]. The three lines below are different installation methods; pick whichever fits your environment. Before using `brew`, `winget`, or `cargo`, make sure the corresponding package manager is already installed.

#code[
  ```bash
  brew install typst                # macOS
  winget install --id Typst.Typst   # Windows
  cargo install --locked typst-cli  # any platform
  ```
]

After installing, switch to the project's root directory in your terminal -- the folder that contains `main.typ` -- and run:

```bash
typst compile main.typ --font-path fonts/
```

This produces `main.pdf` in the same folder. Open the PDF and confirm the CJK text renders correctly. The

#code[
  ```bash
  --font-path fonts/
  ```
]

flag tells #typst to read the fonts bundled with the project, so you don't need to install them system-wide.

If you have the #link("https://github.com/casey/just")[`just`] build tool installed (a single executable; `brew install just` or follow the instructions on its site), you can instead use the commands below, which run the compilation tasks defined in the project's `justfile`:

#code[
  ```bash
  just compile   # outputs main.pdf (draft, no watermark)
  just watch     # recompiles on save
  just release   # final version, with the school watermark
  just clean     # deletes main.pdf
  ```
]

While writing your thesis, you can run `just watch` from the project root to start *watch mode*. Once started, it keeps monitoring your files; every time you edit and save the thesis content or configuration, #typst recompiles and updates the same `main.pdf` on success, so you don't need to run the compile command by hand each time. Keep that terminal window open while you work; to stop watching, switch back to the terminal and press `Ctrl+C`.

When you need a version with a watermark, stop watch mode first, then run `just release`. That command adds

#code[
  ```bash
  --input watermark=true
  ```
]

which produces a watermark from the image specified in your configuration, and the command exits as soon as compilation finishes -- it doesn't keep watching files. Note that `just watch` and `just release` both write to `main.pdf`; if you restart `just watch` afterward, the PDF will be overwritten again by the watermark-free draft version.

== Project Structure

After downloading or cloning the project, it's worth taking a moment to learn what each folder is for, so that you'll know exactly where to look when you need to change something later. #ref(<tbl:layout>) lists the files and directories in the project.

#tlt(
  caption: [Directories and Files],
  columns: (auto, 1fr),
  align: (left + horizon, left + horizon),
  header: ([Path], [Purpose]),
  rows: (
    ([`config.yml`], [Your thesis data: title, author, department, dates, keywords]),
    ([`main.typ`], [Binding order: front matter, chapters, references, appendices]),
    ([`contents/`], [Thesis content. `front/` holds the abstract and acknowledgements; `back/` holds appendices and the `.bib` file]),
    ([`schools/`], [Per-school format settings. `default.yml` is the single source of defaults]),
    ([`lib/`], [Template core, independent of any particular thesis; you generally won't touch this]),
    ([`helper/`], [Tools specific to this thesis: figures, three-line tables, code styling]),
    ([`misc/`], [#typst logos, lorem-ipsum helpers, and other text utilities]),
    ([`figures/`], [Thesis figures and the sample images used in this tutorial]),
    ([`assets/`], [Template assets such as school watermarks]),
    ([`docs/`], [Original PDFs of each school's thesis format regulations]),
  ),
  notes: [Edit `schools/` to change format rules, and `contents/` to change the text content.],
) <tbl:layout>

For the most part you'll only be editing `config.yml`, `main.typ`, and `contents/`. Put your thesis figures in `figures/`; look at `helper/` when you need to adjust shared styling for figures, tables, or code blocks. Keep the following line at the top of every content file so you can use the helper functions covered in this tutorial.

#code[
  ```typ
  #import "/helper/mod.typ": *
  ```
]

== Editing the Configuration File

Once you've confirmed a successful compile, open the configuration file `config.yml` at the project root and start by replacing the title, name, department, and date with your own information. Below are the commonly used fields; be sure to also fill in the English-language fields in the original file, or a given language will end up missing content:

#code[
  ```yaml
  title: "分散式系統的一致性研究"
  title-en: "A Study on Consistency in Distributed Systems"

  author: "王小明"
  author-en: "Wang, Xiao-Ming"
  id: "111753001"

  advisor: "陳大文"
  advisor-en: "Chen, Da-Wen"

  college: "資訊學院"
  institute: "資訊科學系"

  degree: "碩士"
  type: "論文"

  date: "2027-01-15"       # 封面上的日期
  oral-date: "2026-12-20"  # 印在審定書上的口試日期

  keywords: ["分散式系統", "一致性"]
  keywords-en: ["Distributed Systems", "Consistency"]
  ```
]

Dates default to the `YYYY-MM-DD` format. The cover page automatically converts this into the ROC calendar year alongside the English month name, and the verification page automatically applies the oral defense date. Its default format is likewise `YYYY-MM-DD`.

`degree` (Master's/Doctoral) and `type` (Thesis/Technical Report) are used on both the cover page and the verification page. When changing them, be sure to also check the corresponding `degree-en` and `type-en`. Recompile after saving, then check that the Chinese and English cover-page information match, and check the date on the verification page.

== Applying a School Preset

Add `school:` to `config.yml`, or remove the leading `#` from the existing commented-out line, and fill in the school code. For example, to use NCCU's preset:

#code[
  ```yaml
  school: nccu   # 對應 schools/nccu.yml
  ```
]

The built-in school codes are listed in #ref(<tbl:schools>). A code must match the filename in `schools/`, without the `.yml` extension. When no school is specified, the template falls back to the default formatting, and the university name remains as placeholder text.

#tlt(
  caption: [Built-in School Codes],
  columns: (auto, 1fr, auto, 1fr),
  align: (left + horizon, left + horizon, left + horizon, left + horizon),
  header: ([Code], [University], [Code], [University]),
  rows: (
    ([`ntu`], [National Taiwan University], [`ncu`], [National Central University]),
    ([`nthu`], [National Tsing Hua University], [`nsysu`], [National Sun Yat-sen University]),
    ([`nycu`], [National Yang Ming Chiao Tung University], [`nchu`], [National Chung Hsing University]),
    ([`ncku`], [National Cheng Kung University], [`ccu`], [National Chung Cheng University]),
    ([`nccu`], [National Chengchi University], [`ntou`], [National Taiwan Ocean University]),
    ([`ntpu`], [National Taipei University], [`nuk`], [National University of Kaohsiung]),
    ([`ntnu`], [National Taiwan Normal University], [`ncue`], [National Changhua University of Education]),
    ([`nknu`], [National Kaohsiung Normal University], [], []),
  ),
  notes: [The original regulation PDFs for each school are kept in `docs/`, with the revision date in the filename.],
) <tbl:schools>

Configuration files apply in cascading order, with later ones overriding earlier ones:

#code[
  ```text
  schools/default.yml  ←  schools/<school>.yml  ←  config.yml
  ```
]

In other words, you can override any formatting rule directly in `config.yml` without touching the school preset file. The configuration is nested in several levels -- take `layout`, for instance: it contains `margin`, and only inside `margin` do you find the four edge values. Overrides are compared field by field: only what you actually write in `config.yml` gets replaced, and anything not specified keeps its default.

For example, the snippet below only overrides the top margin; the other three sides still follow the school's setting:

#code[
  ```yaml
  layout:
    margin:
      top: 3.5
  ```
]

If you see `unknown key` during compilation, check the field named in the error message first. For example, below `fnot-size` is misspelled and should be `font-size`:

#code[
  ```text
  error: panicked with: /config.yml: unknown key `layout.fnot-size`
         (see schools/default.yml)
  ```
]

Every available key and its default value is documented in `schools/default.yml`, with a comment noting the unit for each one -- that file is the complete list of configuration options.

== Key Files

A printed thesis follows a fixed binding order: cover, verification page, acknowledgements, abstract, table of contents, body, references, appendices. `main.typ` is exactly that order sheet. It contains none of the thesis content itself -- it only states which file goes where, and where chapter numbering begins.

In other words, the content lives in the individual files under `contents/`, and `main.typ` decides their order. To change the binding order, or add or remove a page, you edit this file without touching the content itself. The whole file is short -- start to finish, it's just this:

#code[
  ```typ
  #import "helper/mod.typ": *

  #show: thesis

  // front matter
  #include "contents/front/acknowledgement.typ"
  #include "contents/front/abstract.typ"

  // notation
  #include "contents/front/denotation.typ"

  // chapters
  #set heading(numbering: "1.1")
  #include "contents/chapter01.typ"
  #include "contents/chapter02.typ"

  // references
  #references()

  // appendices
  #include "contents/back/appendix01.typ"
  ```
]

The role of each line is summarized in #ref(<tbl:main>).

#tlt(
  caption: [What Each Line of `main.typ` Does],
  columns: (7.5cm, 1fr),
  align: (left + horizon, left + horizon),
  header: ([Line], [Role]),
  rows: (
    ([`#import "helper/mod.typ": *`], [Loads the configuration and helper functions]),
    ([`#show: thesis`], [Applies the template and generates the cover, verification page, table of contents, list of figures, and list of tables]),
    ([`#include "contents/front/..."`], [Front-matter pages, in the order this file lists them]),
    ([`#set heading(numbering: "1.1")`], [Chapter numbering starts only after this line]),
    ([`#include "contents/chapterNN.typ"`], [The body's chapters -- the `#include` order sets the chapter numbers]),
    ([`#references()`], [The bibliography; lets you set where the reference file lives]),
    ([`#include "contents/back/..."`], [Appendices; the appendix file itself switches numbering to `A.1`]),
  ),
  notes: [The cover and verification page are generated by `#show: thesis`.],
) <tbl:main>

A few things worth noting:

1. Numbering boundary: `#set heading(numbering: "1.1")` marks the boundary for numbering -- `=` headings written before it are left unnumbered, so acknowledgements and the abstract don't become "Chapter 1"; headings written after it are numbered.

2. Chapter numbers follow the order of the `#include` lines, not the filename -- for example, moving the `chapter03.typ` line above `chapter02.typ` makes it Chapter 2.

3. Although filenames don't affect the result, it's still a good idea to keep them consistent with the order, so you don't lose track of which file is which later.

== Adding and Removing Chapters

The template splits content into one file per chapter, all kept in `contents/`, with filenames numbered by chapter order, e.g. `chapter01.typ`, `chapter02.typ`. Editing one chapter doesn't touch the others, and when a compile error occurs it's easy to tell which file is at fault.

The `#include` lines in `main.typ` decide the order of the chapters, and you maintain them yourself when adding or removing chapters.

To add a chapter, create `contents/chapter05.typ` (files are named by chapter number) with an `#import`, a chapter heading, and a section heading, then add `#include "contents/chapter05.typ"` in `main.typ` before `#references()`.

#code[
  ```typ
  #import "/helper/mod.typ": *

  = Chapter Title

  == Section Title

  Body text.
  ```
]

To remove a chapter, delete the file and also remove its `#include` line from `main.typ`; otherwise #typst can't find the file and compilation fails outright. The numbers of later chapters shift up automatically, and `@cha:...` references in the text update with them -- nothing to fix by hand.

The front matter (`contents/front/`) and appendices (`contents/back/`) work the same way: create the file and add an `#include` line at the matching spot in `main.typ`; when deleting one, remove that line too.

== Writing Chapter Content

Once a chapter file exists, you can start writing. Keep the `#import` on the first line -- it loads the configuration and the figure/table helper functions; if you remove it, `#fig()` and `#tlt()` will stop working in that chapter. It's a good idea to lay out the chapter heading and a few section headings first, then fill in the body section by section -- you don't have to write it all at once.

The most basic shape of a chapter looks like this:

#code[
  ```typ
  #import "/helper/mod.typ": *

  = 緒論

  == 研究背景

  第一段內文。

  第二段內文，段落之間空一行。

  === 研究動機

  第三層標題底下的內文。
  ```
]

Headings begin with equals signs, and the number of equals signs is the level: one for a chapter, two for a section, three for a subsection. The font size, alignment, and numbering style at each level are all determined by the school's configuration file, so while writing you only need to choose the right level -- the appearance takes care of itself. A chapter heading also forces a page break automatically, so you don't need blank space at the start or end of the file.

A blank line between paragraphs starts a new paragraph, and first-line indentation is automatic too. Don't manually break lines at the end of each line -- #typst wraps text to fit the page width on its own; a single line break in the source is treated as just a space, and forcing a hard break would only create odd layout artifacts the next time you edit the text.

To make a chapter referenceable, add a label after its heading, e.g. `= 研究方法 <cha:method>`. Anywhere afterward, writing `@cha:method` renders as a clickable "Chapter 3" (or the equivalent), and it updates automatically if the chapter number changes. Figures, tables, and code blocks use the same labeling convention -- see Chapter 3 for details.

== Using Placeholder Text to Preview Layout

Once a chapter's structure is settled but the text isn't written yet, you can fill in placeholder text to lay out the page flow, breaks, and figure positions in advance. `misc/lorem.typ` wraps two functions, each giving five paragraphs by default:

#code[
  ```typ
  #zh-lorem()            // 中文五段
  #en-lorem()            // 英文五段
  #zh-lorem(count: 2)    // 顯示兩段
  #en-lorem(count: 8)    // 顯示八段
  ```
]

The Chinese placeholder text comes from the Traditional Chinese corpus in the #link("https://typst.app/universe/package/kouhu/")[kouhu] package, sourced from #latex's #link("https://ctan.org/pkg/zhlipsum")[zhlipsum]; the English placeholder text comes from the #link("https://typst.app/universe/package/ipsum/")[ipsum] package. Both packages are downloaded and cached automatically on first compile, so later compiles work offline too. To switch to a different source text or change how it's generated, edit those two lines in `misc/lorem.typ`.
