#import "/helper/mod.typ": *

= Layout Settings <cha:layout>

After finishing the settings in Chapter 1, compile once and check the font size, line spacing, and page margins against your department's requirements, then adjust whatever needs changing. This chapter walks through where these settings live and how to use them; it's best to change one thing at a time and check the result before moving on.

The `YAML` examples below can all be pasted directly into `config.yml` as overrides. If a `layout:` block already exists in the file, add the new settings under that existing block, keeping the indentation shown in the examples -- don't create a second block with the same name.

== Fonts and Font Size

Open `config.yml` and set the body font and font size under `layout:`. The defaults are listed below; if things already look right, you can leave these values as-is and only change what your department requires.

#code[
  ```yaml
  layout:
    language: "chinese" # chinese | english 決定標題語言
    font-latin: ["EB Garamond", "Tinos"] # one family or several, tried in order
    font-cjk: ["TW-MOE-Std-Kai", "DFKai-SB"]
    font-size: 12 # pt
  ```
]

The template looks for available glyphs in the order the font list gives them, using `font-latin` first and falling back to `font-cjk` for whatever characters are missing. With the settings above, Latin text prefers EB Garamond, with Tinos (an open-source font whose character widths are identical to Times New Roman's) filling in any characters it lacks, and CJK text prefers the #link("https://language.moe.gov.tw/material/info?m=9fe3fe82-8bbf-44c0-961d-873ea079e284")[Ministry of Education standard Kai typeface] (licensed under CC BY-ND, requiring attribution to "the Republic of China Ministry of Education" when used). These font files are already bundled in the project's `fonts/` directory, so keep this flag when compiling. Both Latin fonts are licensed under the SIL OFL 1.1 and free to redistribute. If your department explicitly requires Times New Roman, set `font-latin` to `"Tinos"`: its character widths match Times New Roman's one for one and its letterforms are similar, so your page breaks won't move. If you must use the original, note that it has redistribution restrictions and the template can't bundle it -- install it on your own computer first, then enter `"Times New Roman"`. EB Garamond's widths differ from Times New Roman's (by about 7% on average), so switching to it changes where every page breaks:

#code[
  ```bash
  --font-path fonts/
  ```
]

To switch to a system font or one required by your department, just put its name into `font-latin` or `font-cjk`. The tricky part here is that the name you enter must match the family name recorded inside the font file itself, not the name shown in an installer or on a font website -- the two sometimes differ. #ref(<tbl:font-name>) lists ways to look up the family name in a few common situations.

#tlt(
  caption: [Looking Up a Font's Family Name],
  columns: (auto, 1fr),
  align: (left + horizon, left + horizon),
  header: ([Situation], [How to find it]),
  rows: (
    (
      [The font file is already in `fonts/`],
      [Run `typst fonts --font-path fonts/` -- the name it prints is the family name Typst actually reads, so it's the most reliable source to copy into the config.],
    ),
    (
      [A font already installed on macOS],
      [Open Font Book and select the font to see its name.],
    ),
    (
      [A font already installed on Windows],
      [Open Settings -> Personalization -> Fonts, then click into the font's page to see its name.],
    ),
    (
      [Downloaded from Google Fonts or similar],
      [The name shown on the page is usually the family name, but after downloading it's still worth dropping it into `fonts/` and double-checking with `typst fonts`.],
    ),
  ),
  notes: [When unsure, always trust the name `typst fonts --font-path fonts/` prints after the file is in `fonts/`.],
) <tbl:font-name>

To change the body text to 14pt, set `font-size` to `14` under `layout:` -- there's no need to add a unit after the number. After changing it, find a page with mixed Chinese/English text and check that both scripts look right at the new size. Chapter headings have their own font-size settings, adjustable separately under the `heading:` block below.

== Line Height and Paragraphs

Line spacing, paragraph spacing, first-line indentation, and left/right justification for the body text all live under `layout:`. Pick a page with a few full paragraphs, apply the settings below, and compare the spacing between lines, between paragraphs, and the indentation at the start of each paragraph.

#code[
  ```yaml
  layout:
    line-height: 1.5      # 行高 1.5 倍
    par-spacing: 1.2      # em，段落之間的間距
    first-line-indent: 2  # em，中文習慣首行縮排兩個字
    justify: true         # 左右對齊
    line-box:             # em，見下方說明
      top: 0.88
      bottom: -0.12
  ```
]

When adjusting paragraphs, it's best to start with `line-height` and `first-line-indent`. With a 12pt body font and `line-height` set to `1.5`, the baseline-to-baseline spacing for a regular text line is 18pt; with `first-line-indent` set to `2`, two character-widths of space are reserved. If your department requires paragraphs without indentation, set `first-line-indent` to `0`.

`par-spacing` controls the gap between two paragraphs, defaulting to `1.2`, in `em` units; in `YAML` you only enter the number, without a unit. A larger value adds more whitespace between paragraphs. Text separated by a blank line in the chapter source forms separate paragraphs, so you can compare adjacent paragraphs to see the effect of your change.

If you'd like paragraphs to keep only their normal line spacing with no extra gap, set `par-spacing` to `0`. #typst takes the larger of the paragraph spacing and the line-leading value `par(leading)`, so paragraphs won't collide just because `par-spacing` is `0`. The template converts `line-height` minus `1` into em units to use as `leading`; for example, `line-height: 1.5` corresponds to `0.5em`, so setting `par-spacing` to `0.5` or smaller won't add any extra paragraph gap in that case.

`line-box` sets the top and bottom edges of a text line, with the two differing by 1em by default, which the template uses to compute line spacing. When first adjusting it, keep the `top` and `bottom` values as they are and observe line spacing in a plain paragraph. If a paragraph also contains a tall formula or image, check separately whether that line needs extra room.

== Margins and Paper Size

Paper size is set by `paper`, and the four margins are set separately under `margin:`. The example below uses A4 paper; if you've already selected a school preset, check the result it produces first and only add the margin values you need to override.

#code[
  ```yaml
  layout:
    paper: "a4"
    margin: # cm
      top: 3
      bottom: 2
      left: 3
      right: 3
  ```
]

Enter the four margin values under `margin:` in centimeters, as plain numbers. For example, if your department requires a 3.5cm left margin, set `left` to `3.5`, not `3.5cm`. If you only change the left margin, the other three still follow the school preset or the default, without needing to be rewritten.

After changing it, check both the body pages and the cover page to make sure the headings, figures/tables, and cover information all still fit. The template currently has no separate margin setting for the cover page -- its sections are laid out with a mix of fixed and flexible gaps instead; if your thesis title is long, you can adjust the font size or spacing under `cover:` to keep the text from crowding together.

== Headings and Numbering

The font size, alignment, and spacing before/after chapter headings are all grouped under `layout.heading`. The lists below are ordered by heading level, so you can compare the appearance of chapter, section, and subsection headings and adjust the corresponding position in each list.

#code[
  ```yaml
  layout:
    heading:
      size: [18, 16, 14, 12]                     # pt，第 1 至 4 層
      weight: "regular"                          # regular | bold
      align: ["center", "center", "left", "left"]
      line-height: 1.2                           # 標題內部的行距
      gap-above: [1, 0.8, 0.8, 0.6]              # em
      gap-below: [1, 0.5, 0.4, 0.3]              # em
      number-gap: [1, 1, 0, 0]                   # em，編號與標題之間
  ```
]

The lists above correspond in order to heading levels 1 through 4. For example, to adjust the chapter heading's font size, change the first value in `size`; to adjust section headings, change the second value. It's best to keep all four positions and only replace the values you need, so it's easy to compare settings across levels.

To change the text before or after a number, add `strings:` to `config.yml` at the same level as `layout:`. The example below makes chapters and sections use the phrasing "Chapter One" and "Section One" (in the Chinese wording "第一章"/"第一節"):

#code[
  ```yaml
  strings:
    chapter: ["第", "章"]   # 第一章
    section: ["第", "節"]   # 第一節
    subsection: "、"        # 一、
    appendix: ["附錄 ", ""] # 附錄 A
  ```
]

Back in a chapter file, add `=` before a heading to set its level. One `=` is a chapter heading, two is a section heading, and so on. Leave one space between the equals signs and the heading text, and structure headings by their actual level:

#code[
  ```typ
  = 研究方法      // 第一層，章號依出現順序自動產生
  == 實驗設計     // 第二層，印成第一節
  === 資料來源    // 第三層，印成一、
  ==== 前處理     // 第四層，不編號
  ```
]

At compile time, a level-1 heading always starts a new page automatically, and the chapter number is generated in the order the headings appear. So you only need to write the heading text -- e.g. "Research Methods" -- without manually adding "Chapter 3" or inserting a page break. Adding or reordering chapters and recompiling updates the numbering automatically.

== Caption Position for Figures, Tables, and Code <sec:caption>

The caption position for figures, tables, and code blocks can each be set independently. Under `layout:` in `config.yml`, find `caption-position:` and set whichever item you want to `"top"` or `"bottom"`, meaning above or below the content. Here are the current defaults:

#code[
  ```yaml
  layout:
    caption-position:
      image: "bottom"    # 圖片標題放在下方
      table: "bottom"    # 表格標題放在下方
      code: "bottom"     # 程式碼標題放在下方
  ```
]

For example, to move all table captions to the top, just change `table` to `"top"` -- figures and code blocks are unaffected. The figure setting also applies to the combined caption on row and grid figures. Recompile after changing it and check the caption's position relative to the content; there's no need to edit each chapter's figures and tables individually.

== Table of Contents and Page Numbers

The depth, indentation, and page-number format for the table of contents all live under `outline:`, at the same level as `layout:`. Below are the commonly used settings; when first using the template, you can leave the defaults as they are and adjust them once the chapter content is complete.

#code[
  ```yaml
  outline:
    depth: 3            # 目次收到第幾層
    indent: 1           # em，每層縮排一個字
    title-size: 16      # pt，目次、圖次、表次的字級
    page-numbering: "i" # 前置部分：i, ii, iii
    body-numbering: "1" # 正文開始：1, 2, 3
    entry-gap: 1        # em，章與章之間的間距
    entry-bold: true    # 章標題在目次裡加粗
  ```
]

The table of contents is generated automatically from chapter headings, and the lists of figures and tables collect all the figures and tables in the document. To list only chapters and sections in the table of contents, set `depth` to `2` -- the headings in the body text keep their original levels regardless. After compiling, you can click a table-of-contents entry to confirm it jumps to the right place.

To change the titles of these three pages, set the text under `titles:`. A `~` in the string becomes a character-spacing gap -- for example `"目~次"` spreads the two characters apart; to show "目錄" directly, just enter `"目錄"`:

#code[
  ```yaml
  titles:
    toc: "目~次"   # 有些學校用「目錄」
    lof: "圖~次"
    lot: "表~次"
  ```
]

The position and displayed text of the page number live under `page-number:`, at the same level as `outline:`. Below are all defaults, so you can use them as-is without changes:

#code[
  ```yaml
  page-number:
    position: "bottom" # top：頁首；bottom：頁尾
    align: "center"    # left：靠左；center：置中；right：靠右
    format: "{page}"   # {page} 會替換成該頁的頁碼
  ```
]

Each setting can be adjusted per the table below. Setting `position` to `"top"` and `align` to `"right"` moves the page number to the top-right corner of the page.

#tlt(
  caption: [Page Number Settings],
  columns: (7em, 1fr),
  align: left + horizon,
  header: ([Parameter], [Use and example]),
  rows: (
    ([`position`], [Position: `"top"` for a header, `"bottom"` for a footer (default).]),
    ([`align`], [Alignment: `"left"`, `"center"` (default), `"right"`.]),
    ([`format`], [Displayed text: e.g. `"Page {page}"`; set to `""` to hide the page number.]),
  ),
)

`{page}` in `format` is replaced by the page number, e.g. `"第 {page} 頁"` shows as "第 1 頁" ("Page 1"); it can also be written as `"論文・{page}"`. Any other text is displayed literally and is never interpreted as #typst syntax.

`outline.page-numbering` and `outline.body-numbering` control the numbering style for the front matter and the body respectively, defaulting to lowercase Roman numerals and Arabic numerals. `page-number.format` only changes the displayed text at the top or bottom of the page -- the table of contents keeps its own page-number format. The cover and verification pages never display a page number. After finishing your chapter adjustments, check that the first page of the body and the entries in the table of contents point to matching page numbers.

== Watermark and Final Copy

If you need to add a watermark before submission, first check whether the school preset already specifies an image. To set your own, add the block below to `config.yml`, change `image` to the path of the file you want to use, and adjust its size and opacity.

#code[
  ```yaml
  watermark:
    image: "/assets/watermarks/nccu.pdf"
    width: 100    # %，佔頁寬的比例，置中
    opacity: 100  # %，100 是原圖深淺，50 會刷淡一半
  ```
]

Once the image is set, run `just release` and check the watermark on the body pages of the resulting PDF. A regular `just compile` never enables the watermark, and it's never added to the cover or front matter either way. If `image` is set to `~`, meaning no image is specified, nothing will show even when running `just release`.

To use your own watermark, first place the image file in `assets/watermarks/`, then update the `image` path. You can adjust `width` to change how much of the page width the image covers, or lower `opacity` to make the watermark lighter. Whether you need to add a watermark at all depends on your school's submission requirements.

If you don't have `just` installed, you can instead run the following command from the project root, which produces the same `main.pdf`:

```bash
typst compile main.typ --font-path fonts/ --input watermark=true
```
