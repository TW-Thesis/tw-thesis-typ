#import "/helper/mod.typ": *

= Citations, Code, and Appendices

This chapter continues with citations, code blocks, and appendices. The examples in each section are independent of one another -- copy whichever one you need and swap in your own thesis data.

Bibliography and appendix files live in `contents/back/`; the rest of the examples can be written directly into this chapter. When you move or edit content, remember to keep the corresponding `#include` lines in `main.typ` in sync, so the order of the references or appendices doesn't get scrambled.

== Citing Sources

`.bib` is a plain-text bibliography database in #bibtex format, with one entry per reference, in the form `@type{identifier, field = {value}, ...}`. `contents/back/references.bib` already includes a few sample entries; here's what one looks like:

#code[
  ```
  @inproceedings{kocher99,
    author =       {C. Kocher and J. Jaffe and B. Jun},
    title =        {Differential Power Analysis},
    editor =       {M. Wiener},
    booktitle =    {Advances in Cryptology ({CRYPTO}~'99)},
    series =       {Lecture Notes in Computer Science},
    volume =       1666,
    pages =        {388-397},
    publisher =    {Springer-Verlag},
    month =        {August},
    year =         1999
  }
  ```
]

`@inproceedings` is the entry type (a conference paper); other common ones include `@article` (journal article), `@book` (book), and `@incollection` (book chapter) -- the type affects which fields show up on the references page. `kocher99` is the identifier used to cite this entry in the body text, and it must be unique within a `.bib` file; the fields that follow, like `author`, `title`, and `year`, are the entry's data -- fill them in field by field, in any order, without affecting how it's typeset.

Under the "Cite" button below each Google Scholar search result, the popup includes a #bibtex link you can click to copy the whole entry; library databases (such as IEEE Xplore or the ACM Digital Library) usually have an "Export Citation" or "Cite" option on the reference's page too, where you can choose the #bibtex format. If you use reference managers like Zotero or EndNote, they can likewise export a `.bib` file directly. Once you have the entry, paste it into `references.bib`, rename the identifier to something you'll remember (e.g. `author-surname+year`), and confirm it doesn't collide with any existing identifier.

Once your bibliography data is ready, go back to your chapter file and cite it using the same identifier. Use `cp()` to place the citation at the end of a sentence, or `c()` to weave the author's name into the sentence itself. Below are also the forms that show only the author or only the year, to use as your sentence requires.

#code[
  ```typ
  #cp("kocher99")   // \citep，括號引用
  #c("kocher99")    // \citet，行文引用
  #ca("kocher99")   // \citeauthor，只要作者
  #cy("kocher99")   // \citeyear，只要年份
  ```
]

The difference between the four functions once compiled is shown below -- check these first, then swap in the identifiers of the sources you want to cite:

#tlt(
  caption: [Citation Function Comparison],
  columns: (auto, auto, 1fr),
  align: left + horizon,
  header: ([Function], [Result], [Use]),
  rows: (
    ([`cp("kocher99")`], [#cp("kocher99")], [`\citep`, a parenthetical citation, placed at the end of a sentence]),
    ([`c("kocher99")`], [#c("kocher99")], [`\citet`, an in-text citation, weaving the author into the sentence]),
    ([`ca("kocher99")`], [#ca("kocher99")], [`\citeauthor`, showing only the author]),
    ([`cy("kocher99")`], [#cy("kocher99")], [`\citeyear`, showing only the year]),
  ),
) <tbl:cite-forms>

To cite a specific passage in a book, use `supplement` to add a page number or section. The example below uses the `companion` entry and adds "p. 42"; when applying this to your own thesis, change it to the actual location you're citing:

#code[
  ```typ
  #cp("companion", supplement: [p. 42])
  ```
]

Compiled, this displays as #cp("companion", supplement: [p. 42]). The page number is typeset together with the citation, and the punctuation and layout follow whichever bibliography style you've selected.

If you'd rather not call a function at all, you can also use #typst's native citation syntax. For example, writing `@IEEE-1363` in the body text produces @IEEE-1363. This form and `cp()` both draw on the bibliography style set in the configuration file, so you can pick whichever style you find more comfortable.

== Bibliography Settings

Open `config.yml` and add whatever settings you need to the existing `bibliography:` block. `path` specifies the bibliography file(s), and `style` determines the citation format; if your data is spread across multiple files, add each path in order to the `path` list.

#code[
  ```yaml
  bibliography:
    path: ["/contents/back/references.bib"] # 可以給多個檔案
    style: "apa"       # 內建 CSL 樣式名稱，或 .csl 檔案路徑，見下方對照表
    title: "參~考~文~獻"
    color: "#0000ff"   # 引用與連結的顏色，要黑白印就改成 "#000000"
    full: false        # true 會把沒引用到的條目也列出來
  ```
]

`style` determines the logic used to typeset the bibliography, and broadly falls into three systems: author-date styles show the author's name and year in the body text, letting readers gauge at a glance how recent a piece of research is; author-page styles show the author and a page number in the body text, making it easy to locate the exact passage in the source; numeric styles leave only a number or superscript in the body text, with the list ordered by number, which reads with the least interruption. #typst has more than eighty built-in CSL styles; a few common ones by field are listed below:

#tlt(
  caption: [Common Citation Styles],
  columns: (5em, 7em, 11em, 12em),
  align: left + horizon,
  header: ([Style], [System], [Common fields], [`style` value]),
  rows: (
    ([APA], [Author-date], [Psychology, education, social sciences], [`apa`]),
    ([Harvard], [Author-date], [Business, social sciences], [`harvard-cite-them-right`]),
    ([Chicago], [Author-date], [History, humanities], [`chicago-author-date`]),
    ([MLA], [Author-page], [Literature, languages, the arts], [`mla`]),
    ([IEEE], [Numeric], [Computer science, EE, engineering], [`ieee`]),
    ([Vancouver], [Numeric], [Medicine, nursing], [`vancouver`]),
  ),
) <tbl:citation-styles>

Just change `style` to the value in the last column of the table above -- for example, changing `"apa"` to `"ieee"` switches both the in-text citations and the final reference list to the corresponding style at once, with no need to separately adjust how `cp()`, `c()`, and the other functions are called. After changing it, check both the body text and the references page to confirm how authors, years, or numbers are displayed.

The list above only covers the most common styles -- there are far more built in than what's shown here. If your department requires a format that isn't among them (for example, Bluebook, common in law, which #typst doesn't currently include), you can obtain the corresponding `.csl` style file yourself and set `style` to that file's path instead, e.g. `style: "/misc/my-style.csl"`.

The default `full: false` only lists sources actually cited in the body text. If you add a new entry and it still doesn't show up in the list, first check whether the body text actually cites it, and whether the identifier's capitalization matches exactly. To temporarily list every entry in the bibliography file regardless of citation, set it to `true`, which is handy for checking your data entry by entry.

Where the reference list is inserted is determined by `#references()` in `main.typ`. Below, it's placed after Chapter 4 and before the appendices; if your department requires a different binding order, just move this line -- there's no need to manually copy the reference list around:

#code[
  ```typ
  #include "contents/chapter04.typ"

  #references()                            // 參考文獻

  #include "contents/back/appendix01.typ"  // 附錄
  ```
]

== Code Blocks

To list code in your thesis, you can create a code block directly in a chapter file. The template applies a monospace font, a light gray background, and line numbers, and highlights the syntax for whichever language you specify. Pick the language name that matches your content -- e.g. `python`, `bash`, or `typ` -- and fill in the code.

To create a code block, wrap the code you want displayed in backticks, adding the language name right after the opening backticks. The closing three backticks go on their own line, marking the end of the block. Here's an example in Python:

#code[
  ````typ
  ```python
  def solve(n):
      return sum(range(n))
  ```
  ````
]

If the code block needs a caption and a number, wrap the whole block in `#code()` and fill in `caption`. To reference it from the body text, add a label at the end too, the same way as with figures and tables in the previous chapter:

#code[
  ````typ
  #code(caption: [遞迴版本])[
  ```python
  def fib(n):
      return n if n < 2 else fib(n - 1) + fib(n - 2)
  ```
  ]<lst:fib>
  ````
]

Note that code blocks have no caption or number by default -- the example below uses that plain form. When you do need a caption, fill in `caption` as shown above, and reference the labeled code block with `#ref(<lst:fib>)`. The caption sits below the block by default; to move it above, set `layout.caption-position.code` to `"top"`.

#code[
  ```python
  def fib(n):
      return n if n < 2 else fib(n - 1) + fib(n - 2)
  ```
]

When a code block runs longer than one page, it breaks across pages automatically, just like a table, and the line numbers keep counting continuously -- there's no need to split it into multiple blocks by hand. This works both for a plain backtick block and for one wrapped in `#code()` with a caption; when there's a caption, the whole block still shares a single number and caption across the page break.

A single-line code block doesn't show line numbers. If you're just mentioning a command or filename within a sentence, wrap the text in a single pair of backticks, for example

#code[
  ```typ
  `just release`
  ```
]

This inline form keeps the monospace font, with a font size and baseline matching the surrounding text, and adds no background or border.

If you need to adjust the appearance of code blocks, open `helper/code.typ` and edit the `code-theme` block near the top. Changes there apply to the shared code style everywhere, so you don't need to edit each chapter's examples individually; `size` controls the block's font size, while inline code still follows the font size of its surrounding paragraph. Here are the available settings:

#code[
  ```typ
  #let code-theme = (
    font: ("DejaVu Sans Mono",), // 等寬字體，可以放自己的字型
    size: 0.95em,                // 相對於本文字級
    fill: luma(248),             // 底色
    rule: 0.6pt + luma(180),     // 上下細線
    number: luma(140),           // 行號顏色
    inset: 0.6em,                // 內距
  )
  ```
]

#tlt(
  caption: [Code Style Parameters],
  columns: (7em, 1fr),
  align: left + horizon,
  header: ([Parameter], [Use and example]),
  rows: (
    ([`font`], [Monospace font; e.g. `("DejaVu Sans Mono",)`.]),
    ([`size`], [Block font size; e.g. `0.95em` -- inline code still follows the surrounding text.]),
    ([`fill`], [Block background color; e.g. `luma(248)`.]),
    ([`rule`], [Top/bottom divider line; e.g. `0.6pt + luma(180)`.]),
    ([`number`], [Line-number color; e.g. `luma(140)`.]),
    ([`inset`], [Block padding; e.g. `0.6em`.]),
  ),
)

== Appendices

For questionnaires, supplementary data, or lengthy derivations, put them in an appendix file under `contents/back/`. Set the appendix numbering at the top of the file first, then add the heading and content. The example below shows the first appendix, which compiles with letter numbering (A, B, ...):

#code[
  ```typ
  #set heading(numbering: "A.1")
  #counter(heading).update(0)

  = 問卷內容 <appendix-a>

  == 第一部分
  ```
]

The first line in the example switches the heading-numbering style, and the second resets the heading counter to zero. As a result, the next level-1 heading appears as "Appendix A," and level-2 headings use the `A.1` style. When you swap in your own content, you only need to change "問卷內容" (the appendix title) and the section headings -- there's no need to type a letter or number into a heading by hand.

To add a second appendix, create another `.typ` file, likewise setting `#set heading(numbering: "A.1")` at the top, but without the counter-reset line this time. Then, in `main.typ`, add the new file's `#include` after the first appendix, and its numbering will continue as B.

Here, `A.1` is a numbering format, where `A` means "count using uppercase letters" -- it doesn't mean this particular appendix must be called A. So a second or third appendix still uses the same setting; don't change it to `B.1` or `C.1`.

== Keeping School Formatting Requirements Up to Date

Each school's thesis format requirements are occasionally revised. `scripts/` provides a downloader that re-fetches the official documents and saves them into `docs/`, so you can check whether your formatting needs to follow suit. You don't need to run this on every compile while writing -- checking occasionally during the writing process is enough.

=== Quick Start: `just update`

The `justfile` at the project root defines an `update` command, which requires #link("https://github.com/casey/just")[`just`] to be installed (a single executable; `brew install just` or follow the instructions on its site -- no need to install uv or node separately). Once it's installed, just run:

#code[
  ```bash
  just update             # 檢查所有學校
  just update ntu nccu    # 只檢查指定學校
  just update --dry-run   # 只回報有無變化，不寫檔
  ```
]

Under the hood, `just update` runs `scripts/python/update_docs.py`, but you don't need to install Python or any packages yourself first: the first time it runs, the command checks whether `uv` (a Python version and package manager) is present on your system, and if not, downloads and installs it automatically into `~/.local/bin` -- no sudo required, and it won't touch any Python already on your system. Every run after that uses this self-contained `uv` installation to build a clean environment, without installing anything system-wide or polluting other projects. If the automatic `uv` install fails (for example, if you're offline), the command falls back to the Node.js version instead, which still requires `node` to already be installed; if neither is available, the command errors out directly with an explanation, rather than failing silently.

=== Running It Manually

If you'd rather not install `just`, you can call the Python or Node.js version directly, with the same effect as `just update`:

#code[
  ```bash
  # Python 版，需要先自行安裝 uv
  cd scripts/python
  uv run update_docs.py --dry-run
  uv run update_docs.py ntu nccu
  uv run update_docs.py

  # 或 Node.js 版，需要先自行安裝 node
  cd scripts/nodeJS
  npm install
  node update-docs.mjs --dry-run
  ```
]

Either way, after downloading new documents you still need to read the requirements yourself and adjust `schools/` accordingly -- the script's job is only to fetch the files; it never modifies your formatting settings automatically.

=== How It Works

Both versions read from the same `scripts/sources.json`, which lists the URL for each school's format document; after downloading, `docs/sources.lock.json` records a hash of each file, so future runs only compare hashes and skip rewriting a file whose content hasn't changed, with the run's output showing "未變更 unchanged" or "已更新 updated" bilingually for each one. If a source is in `.doc` or `.odt` format, you'll also need LibreOffice installed (providing the `soffice` command) so the script can convert the file to PDF before saving it into `docs/`.

=== Scheduling Periodic Checks

Once you've confirmed the manual run works, if you'd like it to check automatically on a schedule, you can add the following to your `crontab`. The example runs every Monday at 6 a.m.; replace the project path with your actual location:

#code[
  ```bash
  0 6 * * 1 cd ~/tw-thesis-typ && just update
  ```
]
