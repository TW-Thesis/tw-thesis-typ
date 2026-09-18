#import "/helper/mod.typ": *

= Figures and Tables

Once your chapter content is ready, you can start adding figures and tables. This chapter first demonstrates a single figure, then covers side-by-side figures, grid figures, plain tables, and three-line tables. When first using these, it's best to paste the examples into your own chapter, confirm they compile, and then swap in your own image paths, captions, and data.

Keep `#import "/helper/mod.typ": *` at the top of the chapter file so the figure and table functions below are available. The template numbers figures and tables automatically, and by default places both captions below the content; to change the position, see #ref(<sec:caption>). The figures and numbers below are all layout examples -- when you use these for your own thesis content, be sure to update the captions and descriptions as well.

== Inserting a Single Figure

To insert a figure, put the image file in the `figures/` folder and pass its path to `fig()`. The example below uses the bundled `/figures/samples/architecture.png`; the leading `/` in the path means the file is looked up from the project root. `width: 60%` sets the figure's width to 60% of the currently available layout width -- compile the example as-is first, then adjust the size to fit your image.

#code[
  ```typ
  #fig("/figures/samples/architecture.png", caption: [研究架構], width: 60%) <fig:one>
  ```
]

The compiled result is shown in #ref(<fig:one>): with the default settings, an automatically generated number and the text from `caption` appear below the image. When you swap in your own figure, update both the path and the caption together; if you're copying this example to add another figure, also change the `<fig:one>` label at the end so each figure has a distinct name for in-text references.

#fig("/figures/samples/architecture.png", caption: [研究架構], width: 60%) <fig:one>

If you need alt text or want to set other options on the image, build the figure with `image()` first and pass that to `fig()`. When using this form, set the image width inside `image()` itself, as in the example below:

#code[
  ```typ
  #fig(
    image(
      "/figures/samples/architecture.png",
      width: 60%,
      height: 5cm,
      fit: "contain",
      alt: "研究流程圖：資料蒐集、資料處理、模型訓練、模型評估、結果分析",
    ),
    caption: [說明],
  )
  ```
]

`width` sets the displayed width of the image; `60%` is six-tenths of the currently available layout width, and you can also use a fixed length like `8cm`. `height` sets the displayed height, computed automatically from the image's original aspect ratio if not given. In this example, width and height together determine the box the image is placed into.

`fit` decides how the original image is fitted into that box: `"contain"` preserves the entire image and its aspect ratio, possibly leaving empty space; `"cover"` also preserves the aspect ratio but crops whatever overflows the box to fill it completely -- this is #typst's default; `"stretch"` stretches the image to the given width and height, which may distort it. If you only set `width` and let `height` be computed automatically, these three modes usually look the same. For charts and diagrams, `"contain"` is usually the safer starting choice, to avoid cropping off text or axis labels.

Other common options include `alt` (a description of the image for screen readers), `page` (which page of a multi-page PDF to insert, defaulting to `1`), and `scaling` (choose `"smooth"` or `"pixelated"` when scaling a raster image). For the full parameter list, see #link("https://typst.app/docs/reference/visualize/image/")[Typst's `image()` documentation]. When you pass an already-built `image()` into `fig()`, set the width inside `image()` -- `fig(width:)` only applies to the form where you pass an image path directly.

== Side-by-Side Figures

To place two figures in the same row, use the `fig-row()` function and pass in each figure's path and sub-caption in order. The sub-captions are automatically numbered `(a)`, `(b)`, and so on, and the whole group shares a single figure number and combined caption, appearing as a single entry in the list of figures. Here's an example with two figures:

#code[
  ```typ
  #fig-row(
    caption: [取樣策略比較],
    ("/figures/samples/sampling-uniform.png", [均勻取樣]),
    ("/figures/samples/sampling-importance.png", [重要性取樣]),
  ) <fig:row>
  ```
]

#fig-row(
  caption: [取樣策略比較],
  ("/figures/samples/sampling-uniform.png", [均勻取樣]),
  ("/figures/samples/sampling-importance.png", [重要性取樣]),
) <fig:row>

If you don't need sub-captions, pass just the path for each figure rather than the `(path, [sub-caption])` pair. If the figures end up compiled too close together, add `gutter: 2em` to increase the space between the columns, then check whether the images still have enough room to display.

#code[
  ```typ
  #fig-row(
    caption: [取樣策略比較],
    gutter: 2em,
    "/figures/samples/sampling-uniform.png",
    "/figures/samples/sampling-importance.png",
  )
  ```
]

Also, for side-by-side figures, `width` is relative to each figure's own column width. For example, setting it to `80%` makes each image take up eight-tenths of its own column. If you need to shrink the figures, adjust this value rather than the source image files.

== Grid Figures

If you have many figures and want them arranged in several rows, use `fig-grid()` instead. `rows` sets the number of rows, and `columns` sets the number of columns per row. The example below places four figures with `rows: 2, columns: 2`, arranging them left-to-right, top-to-bottom, into two rows. Sub-captions for each figure and the combined caption for the whole group work the same way as with side-by-side figures.

#code[
  ```typ
  #fig-grid(
    rows: 2,
    columns: 2,
    caption: [模型預測結果],
    ("/figures/samples/a.png", [線性模型]),
    ("/figures/samples/b.png", [決策樹]),
    ("/figures/samples/c.png", [隨機森林]),
    ("/figures/samples/d.png", [神經網路]),
  ) <fig:grid>
  ```
]

#fig-grid(
  rows: 2,
  columns: 2,
  caption: [模型預測結果],
  ("/figures/samples/a.png", [線性模型]),
  ("/figures/samples/b.png", [決策樹]),
  ("/figures/samples/c.png", [隨機森林]),
  ("/figures/samples/d.png", [神經網路]),
) <fig:grid>

All four figures use the same synthetic training data: orange dots are observed values, and blue lines are each model's predictions. This data is purely for layout demonstration and is not the result of a real experiment.

To arrange them as two rows of three, set `rows: 2, columns: 3`. Figures are laid out in the order they're passed; since this example only has four figures, the last two cells of the second row are left blank. `rows` can be omitted, letting the number of rows grow automatically with the figure count; if you do specify a row count, the number of figures can't exceed `rows * columns`. After adjusting, make sure text inside the images is still legible -- if it's too small, reduce the number of columns per row.

#code[
  ```typ
  #fig-grid(
    rows: 2,
    columns: 3,
    caption: [兩列三欄排版示例],
    ("/figures/samples/a.png", [線性模型]),
    ("/figures/samples/b.png", [決策樹]),
    ("/figures/samples/c.png", [隨機森林]),
    ("/figures/samples/d.png", [神經網路]),
  ) <fig:grid-2x3>
  ```
]

The compiled result is shown in #ref(<fig:grid-2x3>):

#fig-grid(
  rows: 2,
  columns: 3,
  caption: [兩列三欄排版示例],
  ("/figures/samples/a.png", [線性模型]),
  ("/figures/samples/b.png", [決策樹]),
  ("/figures/samples/c.png", [隨機森林]),
  ("/figures/samples/d.png", [神經網路]),
) <fig:grid-2x3>

== Tables

There are two ways to write a table: when you need borders around every cell, use #typst's native `table()`; when you only need a three-line table with lines at the top and bottom of the header and at the bottom of the table, use the template's `tlt()`. Both take data the same way -- the only difference is appearance and borders, so pick whichever your thesis or department requires.

=== Plain Tables

When every cell needs a border, use #typst's `table()` directly. `columns: 3` sets three columns, `table.header(...)` supplies the header row, and the data that follows fills in left-to-right, top-to-bottom. Note that the table must be wrapped in `figure()` for it to get a caption and a label that can be referenced from the text.

#code[
  ```typ
  #figure(
    table(
      columns: 3,
      align: center + horizon,
      table.header([批次大小], [準確率（%）], [訓練時間（秒）]),
      [32], [91.2], [48],
      [64], [92.8], [31],
      [128], [92.1], [22],
    ),
    caption: [實驗結果（傳統表格）],
  ) <tbl:traditional>
  ```
]

#figure(
  table(
    columns: 3,
    align: center + horizon,
    table.header([批次大小], [準確率（%）], [訓練時間（秒）]),
    [32], [91.2], [48],
    [64], [92.8], [31],
    [128], [92.1], [22],
  ),
  caption: [實驗結果（傳統表格）],
) <tbl:traditional>

Adjacent cells can be merged. `table.cell(colspan: 2)[文字]` makes a cell span two columns; in the three-column table below, the "Total" row only fills two cells, since "100 samples" already occupies the last two columns and doesn't need a third cell. To make a cell span two rows instead, use `rowspan: 2`; the cell that would be occupied in the row below should then be left out entirely.

#code[
  ```typ
  #figure(
    table(
      columns: 3,
      align: center + horizon,
      table.header([項目], [訓練集], [測試集]),
      [樣本數], [80], [20],
      [總計], table.cell(colspan: 2)[100 筆],
    ),
    caption: [合併儲存格示例],
  ) <tbl:merged>
  ```
]

#figure(
  table(
    columns: 3,
    align: center + horizon,
    table.header([項目], [訓練集], [測試集]),
    [樣本數], [80], [20],
    [總計], table.cell(colspan: 2)[100 筆],
  ),
  caption: [合併儲存格示例],
) <tbl:merged>

=== Three-Line Tables

Unlike a fully bordered table, the three-line table follows the table convention from the #link("https://apastyle.apa.org/style-grammar-guidelines/tables-figures/tables")[APA style], and is most common in fields that lean heavily on statistical data, such as social science, education, and psychology. Without the extra vertical and horizontal rules, the layout looks cleaner, and it's especially easy to read when a whole column is numbers. Most of the official school format guidelines collected in `docs/` don't actually specify which table border style to use -- which one is used in practice is usually a matter of departmental or advisor convention rather than a university-wide rule, so it's worth confirming with your department before you start writing.

The defining feature of a three-line table is that it keeps only three horizontal rules: above and below the header, and at the bottom of the table. With `tlt()`, put the column names in `header` and the data rows in `rows`; the example below reuses the previous data, for easy comparison.

#code[
  ```typ
  #tlt(
    caption: [實驗結果彙整],
    columns: (auto, auto, auto),
    header: ([批次大小], [準確率（%）], [訓練時間（秒）]),
    rows: (
      ([32], [91.2], [48]),
      ([64], [92.8], [31]),
      ([128], [92.1], [22]),
    ),
    notes: [數值為排版示例。],
  ) <tbl:batch>
  ```
]

#tlt(
  caption: [實驗結果彙整],
  columns: (auto, auto, auto),
  header: ([批次大小], [準確率（%）], [訓練時間（秒）]),
  rows: (
    ([32], [91.2], [48]),
    ([64], [92.8], [31]),
    ([128], [92.1], [22]),
  ),
  notes: [數值為排版示例。],
) <tbl:batch>

Once the data is filled in, you can adjust the column widths, alignment, and any notes below the table. Common parameters are listed below:

#tlt(
  caption: [Common `tlt()` Parameters],
  columns: (7em, 1fr),
  align: left + horizon,
  header: ([Parameter], [Use and example]),
  rows: (
    ([`columns`], [`auto` sizes to content; `1fr` shares out the remaining width. E.g. `(3cm, 1fr)`.]),
    ([`align`], [Cell alignment; centered by default, text columns can use `left + horizon`.]),
    ([`inset`], [Cell padding; e.g. `(x: 0.8em, y: 0.3em)`.]),
    ([`thick`/`thin`], [Weight of the top/bottom rules and the header rule; pass this to change just one table, or edit `rules` to change every table at once.]),
    ([`notes`], [Explanatory notes below the table, at 90% of the body text size.]),
    ([`notes-label`], [Prefix for the notes; defaults to the Chinese 「註：」 regardless of thesis language, so override it (e.g. to `[Note: ]`) for an English thesis, or set to `none` to remove it.]),
    ([`header`], [Column names; set to `()` to omit the header.]),
  ),
)

If the data doesn't fit on one page, the table automatically continues its remaining rows onto the next page -- no extra page-break configuration is needed. When it does, the header supplied via `header` and the rules above and below it are repeated on the new page. Afterward, check the break point to make sure readers can still tell which data belongs to which column.

A three-line table can also merge cells: put `table.cell(colspan: 2)[100 筆]` into the corresponding row of `rows`. In the example below, the "Total" row only fills two cells but still spans all three columns in practice -- the only difference from the plain table above is the border style.

#code[
  ```typ
  #tlt(
    caption: [三線表合併儲存格],
    columns: (auto, auto, auto),
    header: ([項目], [訓練集], [測試集]),
    rows: (
      ([樣本數], [80], [20]),
      ([總計], table.cell(colspan: 2)[100 筆]),
    ),
  ) <tbl:tlt-merged>
  ```
]

#tlt(
  caption: [三線表合併儲存格],
  columns: (auto, auto, auto),
  header: ([項目], [訓練集], [測試集]),
  rows: (
    ([樣本數], [80], [20]),
    ([總計], table.cell(colspan: 2)[100 筆]),
  ),
) <tbl:tlt-merged>

The header itself can also be grouped and split into two rows. When several columns share a category (for example, "training set" and "test set" each further broken down into accuracy and loss), split `header` into two rows of content: the first row uses `table.cell(colspan: 2)[...]` to span several columns and label the group name, and the second row supplies the actual name for each column; a column that doesn't need grouping (for example, "Model" on the far left) uses `table.cell(rowspan: 2)[...]` to span both header rows instead, avoiding a blank gap. If you want a short rule under each group name to set it apart, use `cmidrule(column, column)` to mark the range -- it follows the same logic as the #latex `\cmidrule{column-column}` command introduced next, just with two comma-separated arguments instead. A single cell can also carry an extra annotation by appending a superscript like `#super[a]` after its content, matched to an explanation in `notes`:

#code[
  ```typ
  #tlt(
    caption: [分組表頭示例],
    columns: (auto, auto, auto, auto, auto),
    header: (
      table.cell(rowspan: 2)[模型],
      table.cell(colspan: 2)[訓練集], table.cell(colspan: 2)[測試集],
      cmidrule(2, 3), cmidrule(4, 5),
      [準確率（%）], [損失], [準確率（%）], [損失],
    ),
    rows: (
      ([線性模型], [88.1], [0.42], [85.3], [0.51]),
      ([隨機森林], [96.4#super[a]], [0.11], [90.2], [0.28]),
    ),
    notes: [#super[a] 該次訓練提早停止（early stopping），未跑滿完整輪數。],
  ) <tbl:tlt-grouped>
  ```
]

#tlt(
  caption: [分組表頭示例],
  columns: (auto, auto, auto, auto, auto),
  header: (
    table.cell(rowspan: 2)[模型],
    table.cell(colspan: 2)[訓練集],
    table.cell(colspan: 2)[測試集],
    cmidrule(2, 3),
    cmidrule(4, 5),
    [準確率（%）],
    [損失],
    [準確率（%）],
    [損失],
  ),
  rows: (
    ([線性模型], [88.1], [0.42], [85.3], [0.51]),
    ([隨機森林], [96.4#super[a]], [0.11], [90.2], [0.28]),
  ),
  notes: [#super[a] 該次訓練提早停止（early stopping），未跑滿完整輪數。],
) <tbl:tlt-grouped>

The number of cells in `header` must match the number of columns actually occupied by each row in sequence: the first row is `1 + 2 + 2 = 5` (counting the `rowspan` cell), and the second row is `4` (the `rowspan` cell was already counted, so the second row doesn't repeat it); the two rows together must add up to a whole multiple of `columns`, or the table will misalign.

The three rules `tlt()` draws internally are also each broken out as standalone functions, corresponding to `\toprule`, `\midrule`, and `\bottomrule` from the `booktabs` package in #latex:

#tlt(
  caption: [Rule Functions and Their #latex Equivalents],
  columns: (8em, 1fr, 1fr),
  align: left + horizon,
  header: ([Function], [Rule position], [#latex equivalent]),
  rows: (
    ([`toprule`], [Top of the table], [`\toprule`]),
    ([`midrule`], [Below the header, or between blocks of rows], [`\midrule`]),
    ([`bottomrule`], [Bottom of the table], [`\bottomrule`]),
    ([`cmidrule(a, b)`], [Draws a rule under columns `a` through `b` only (inclusive)], [`\cmidrule{a-b}`]),
  ),
) <tbl:booktabs>

When using `tlt()`, you generally won't need these functions directly, since all three rules are drawn automatically; there are only two situations where you'd insert them yourself: adding an extra rule partway through the data (for example, inserting a `midrule` to split `rows` into two subtotaled groups), or bypassing `tlt()` entirely and hand-building a table with #typst's native `table()` to get that booktabs look of horizontal-rules-only. For example:

#code[
  ```typ
  #figure(
    table(
      columns: 3,
      stroke: none,
      align: center + horizon,
      toprule,
      table.header([項目], [第一組], [第二組]),
      midrule,
      [平均值], [91.2], [88.5],
      [標準差], [3.1], [4.2],
      midrule,
      [樣本數], table.cell(colspan: 2)[60],
      bottomrule,
    ),
    caption: [手刻表格搭配 booktabs 線條],
  )
  ```
]

The two arguments to `cmidrule(a, b)` are 1-indexed column numbers, inclusive on both ends, matching #latex's `\cmidrule{a-b}` -- for example, `cmidrule(2, 3)` in the grouped-header example above corresponds to `\cmidrule{2-3}`, both referring to columns 2 through 3. The default rule thickness is `0.08em` for `toprule`/`bottomrule` and `0.05em` for `midrule`/`cmidrule`; `cmidrule(2, 3, stroke: 0.1em)` can thicken just that one rule.

The thickness of `tlt()`'s three rules can also be adjusted. To change just one table, pass `thick:`/`thin:`:

#code[
  ```typ
  #tlt(
    caption: [調粗上下線的表格],
    columns: (auto, auto),
    thick: 0.14em,
    header: ([項目], [數值]),
    rows: (([範例], [1]),),
  ) <tbl:thick>
  ```
]

#tlt(
  caption: [調粗上下線的表格],
  columns: (auto, auto),
  thick: 0.14em,
  header: ([項目], [數值]),
  rows: (([範例], [1]),),
) <tbl:thick>

Comparing this against the rules in @tbl:batch shows the difference the thicker `thick` value makes. To change all tables at once -- including ones hand-built with `toprule`/`midrule`/`bottomrule`/`cmidrule` directly -- to the same thickness, edit the `rules` dictionary at the top of `helper/table.typ`:

#code[
  ```typ
  #let rules = (
    thick: 0.08em, // toprule、bottomrule
    thin: 0.05em, // midrule、cmidrule，以及 tlt() 表頭下方那條線
  )
  ```
]

== Cross-References

To mention a figure or table in the body text, first add `<name>` after it, then refer to it with `#ref(<name>)`. You can pick any name for the label, but it must be unique within the document. The earlier examples already added `fig:grid` and `tbl:batch`, so you can use them directly like this:

#code[
  ```typ
  四張範例圖的排列方式如#ref(<fig:grid>)所示。
  詳細數據見#ref(<tbl:batch>)。
  本章的設定沿用#ref(<cha:layout>)的規則。
  ```
]

After compiling, the labels are replaced with their corresponding numbers, for example: 四張範例圖的排列方式如#ref(<fig:grid>)所示，詳細數據見#ref(<tbl:batch>)，本章的設定沿用#ref(<cha:layout>)的規則。 A chapter reference shows the full level, so #ref(<sec:caption>) displays both the chapter number and the section number. All of these references are clickable, jumping to the corresponding figure, table, or chapter.

After adding or moving a figure or table, the template renumbers it and updates every in-text reference along with it, so you never need to manually fix "Figure N" or "Table N." Chapter headings can be referenced the same way -- just add a label after the heading:

#code[
  ```typ
  = 版面設定 <cha:layout>
  == 邊界與紙張 <sec:margin>
  ```
]

The wording for chapter references can be set under `cross-ref:` in `config.yml`. `C` is the chapter number, `S` the section number, `B` the subsection number; only the numbers actually needed for the label's level are shown. By default, Chinese numerals are used, displaying as "第C章" (Chapter C), "第C章第S節" (Chapter C, Section S), or "第C章第S節第B小節" (Chapter C, Section S, Subsection B) depending on the level. To display `2`, `2.5`, `2.5.1` instead, change it to:

#code[
  ```yaml
  cross-ref:
    numbering: "1"
    chapter: "C"
    section: "C.S"
    subsection: "C.S.B"
  ```
]

To add surrounding text, use `{C}`, `{S}`, `{B}`, e.g. `"第{C}章第{S}節"`. This style only affects in-text chapter/section references and doesn't change headings, the table of contents, figures/tables, citations, or page numbers; appendices still use labels like "Appendix A."

When Chinese text immediately precedes a reference, you can write `依@sec:caption`, which shows no leading space. If Chinese text immediately follows the reference instead, use `依#ref(<sec:caption>)的說明`; writing `@sec:caption的說明` directly would cause #typst to read the following Chinese characters as part of the label name. Punctuation should have whitespace around it only where the sentence calls for it.

To change the displayed name for a specific reference, use `ref()` and fill in `supplement`. For example, the following changes the prefix before the table number to the English word "Table," while the number itself is still generated by the template and doesn't need to be entered manually:

#code[
  ```typ
  #ref(<tbl:batch>, supplement: [Table])
  ```
]

This only affects that one reference. If you need to change the prefix everywhere it appears -- including in captions and the table of contents, like "Figure 1" or "Table 1" -- change it at the source instead of adding `supplement` to every reference.

== Math and Notation

To insert a formula inline within a sentence, wrap the content in `$...$`, e.g. `$E = m c^2$`. For a formula on its own line, leave a space just inside the opening and closing `$`, written as `$ ... $`.

#typst's math syntax differs from #latex -- for example, superscripts don't use `^{}`, fractions use `frac(a, b)` or `a/b`, and Greek letters become symbols just by typing their English spelling (like `alpha`, `Delta`), with no backslash needed. See the full syntax at #link("https://typst.app/docs/reference/math/")[#typst's math documentation]; when writing formulas for the first time, it's best to check the reference rather than assume #latex syntax carries over directly.

#code[
  ```typ
  行內公式 $E = m c^2$，獨立公式：

  $
    integral_0^1 x^2 dif x = 1/3
  $
  ```
]

After compiling, the inline formula $E = m c^2$ sits in the same line as the surrounding text, while the integral below appears on its own line:

$ integral_0^1 x^2 dif x = 1/3 $

To reference a formula later in the text, first enable equation numbering, then add a label after the standalone formula. The example below uses `eq:pythagoras` as the name; referencing it works the same way as figures and tables, by adding `@` before the name:

#code[
  ```typ
  #set math.equation(numbering: eq-numbering)

  $ a^2 + b^2 = c^2 $ <eq:pythagoras>

  如#ref(<eq:pythagoras>)所示。
  ```
]

Here, `eq-numbering` is a numbering rule the template computes from `config.yml`, so you don't need to hand-write `"(1)"`. By default, every formula is numbered consecutively, showing as `(1)`, `(2)`, ...; if your department requires numbering by chapter instead (e.g. formulas in Chapter 3 showing as `(3.1)`, `(3.2)`, then restarting at `(4.1)` in Chapter 4), set the following under `layout:` in `config.yml`:

#code[
  ```yaml
  layout:
    equation-numbering: "1"      # 1 | a | A | i | I | *
    equation-per-chapter: true   # true 讓公式編號改成「章.流水號」，並每章重新編號
  ```
]

`equation-numbering` only determines the style of the running number itself, working the same way as `footnote-numbering`; the chapter number always uses Arabic numerals, regardless of this setting.

If your thesis repeatedly uses abbreviations or mathematical notation, you can collect them into the notation list in the front matter. Open `contents/front/denotation.typ`, keep the import and style settings at the top, and add entries using the term-list syntax below. Each line starts with `/`, with the symbol before the colon and its full name or definition after:

#code[
  ```typ
  / CNN: 卷積神經網路 (Convolutional Neural Network)
  / $eta$: 學習率 (learning rate)
  ```
]

== Figure and Table Captions

The words "圖" (Figure) and "表" (Table) -- wherever they appear, in figure/table captions, in the lists of figures and tables, and in in-text references -- are all set centrally under `strings:` in `config.yml`, so you never need to edit them one by one:

#code[
  ```yaml
  strings:
    figure: "插圖" # 中文論文的圖說前綴，預設「圖」
    figure-en: "Fig." # language: english 時使用，預設 "Figure"
    table: "附表" # 中文論文的表說前綴，預設「表」
    table-en: "Tab." # language: english 時使用，預設 "Table"
  ```
]

After recompiling, every figure and table produced by `fig()`, `fig-row()`, `fig-grid()`, and `tlt()` picks up the new prefix, and the wording in the lists of figures/tables and in `@name` references updates too. If only one particular figure or table needs a different prefix from the rest, add `supplement:` to that one call -- it won't affect the global setting in `config.yml`:

#code[
  ```typ
  #fig(
    "/figures/samples/architecture.png",
    caption: [說明],
    supplement: [附圖]
  ) <fig:special>
  ```
]

`supplement` can also be left as an empty string `[]`, or set to `none`, in which case the figure or table shows only its number, with no prefix text.

== Footnotes

When a figure or table needs extra clarification, the earlier grouped-header example added `#super[a]` to a cell and matched it to an explanation in `notes` -- but that's just a hand-set superscript character, not a real footnote. To insert a footnote anywhere in the body text, automatically numbered and typeset by #typst, use `#footnote[...]` instead -- there's no separate file to edit, and the numbering, superscript, and the rule at the bottom of the page are all handled automatically:

#code[
  ```typ
  這一點有些爭議#footnote[不同研究對此看法不一。]，後續章節會再討論。
  ```
]

Compiled, it looks like this:

這一點有些爭議#footnote[不同研究對此看法不一。]，後續章節會再討論。

At the bottom of the page, numbering starts at 1 and accumulates continuously through the whole document, never resetting at a page break. If the same note needs to be cited in more than one place, first label the `#footnote[...]` where it's used the first time, and afterward you can reuse the same number with `#footnote(<label>)`, without creating a new note:

#code[
  ```typ
  第一次提到#footnote[說明文字。] <fn:first>，第二次提到時#footnote(<fn:first>)。
  ```
]

The numbering format and whether it restarts each chapter are both set under `layout:` in `config.yml`:

#code[
  ```yaml
  layout:
    footnote-numbering: "1"      # 1 | a | A | i | I | *
    footnote-per-chapter: false  # true 讓每章從 1 重新編號
  ```
]

`footnote-numbering` works the same way as numbering settings like `outline.body-numbering`: `"1"` is Arabic numerals, `"a"`/`"A"` is lowercase/uppercase letters, `"i"`/`"I"` is lowercase/uppercase Roman numerals, and `"*"` cycles through asterisk, double-asterisk, and so on, suited to a thesis with only a handful of footnotes overall. `footnote-per-chapter` defaults to `false`, so footnote numbers accumulate continuously through the whole document; if your department requires numbering to restart at 1 in each chapter, set it to `true` -- there's no need to manually reset the count at the start of each chapter.

Now that the syntax for figures, tables, footnotes, and formulas is settled, the next chapter covers citations, along with code blocks and appendices.
