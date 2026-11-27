// Global text, paragraph, figure and citation rules

#let global-rules(cfg, body) = {
  let l = cfg.layout

  // pin the line box to 1em, so line advance is exactly line-height x font size,
  // which is what 行高 means; typst's own edges move with the font
  set text(
    // font-latin may be one family or a list, tried in order
    font: (if type(l.font-latin) == array { l.font-latin } else { (l.font-latin,) }) + l.font-cjk,
    size: l.font-size,
    lang: if l.language == "chinese" { "zh" } else { "en" },
    region: if l.language == "chinese" { "TW" } else { "US" }, // 圖/表, not 图/表
    top-edge: l.line-box.top,
    bottom-edge: l.line-box.bottom,
  )

  // `all: true` also indents the paragraph right after a heading, as Taiwan
  // theses do; without it typst skips that one
  let indent = if l.first-line-indent-all {
    (amount: l.first-line-indent, all: true)
  } else {
    l.first-line-indent
  }
  set par(
    justify: l.justify,
    leading: (l.line-height - 1) * 1em,
    spacing: l.par-spacing,
    first-line-indent: indent,
  )

  set footnote(numbering: l.footnote-numbering)

  // Caption positions follow the merged school and thesis settings.
  show figure.where(kind: image): set figure.caption(position: l.caption-position.image)
  show figure.where(kind: table): set figure.caption(position: l.caption-position.table)
  show figure.where(kind: "code"): set figure.caption(position: l.caption-position.code)
  show figure.where(kind: table): set block(breakable: true)
  // A figure breaks Typst's run of paragraphs; a zero-height paragraph keeps
  // the following body paragraph indented without changing heading behavior.
  show figure: it => {
    it
    ""
    context v(-par.spacing - measure("").height)
  }

  show cite: set text(fill: cfg.bibliography.color)
  show ref: set text(fill: cfg.bibliography.color)

  body
}
