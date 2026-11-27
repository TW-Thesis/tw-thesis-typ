// Heading numbering, heading cross-references and appendix labels

#import "util.typ": fill

// appendices set their own pattern ("A.1", "B.1", ...), which starts with a
// letter; the body's pattern ("1.1") starts with a digit and is numbered
// 第一章 / 第一節 instead
#let is-appendix = n => (
  type(n) == str and n.len() > 0 and not "0123456789".contains(n.first())
)

#let heading-rules(cfg, body) = {
  let l = cfg.layout
  let hd = l.heading
  let s = cfg.strings
  let cr = cfg.cross-ref

  show heading: set par(
    leading: (hd.line-height - 1) * 1em,
    first-line-indent: 0em,
  )

  // Dot-separated C/S/B is a compact preset; braces also work in prose.
  let cross-ref-format = (template, nums) => {
    let tokens = template.split(".")
    let pattern = if tokens.all(token => token in ("C", "S", "B")) {
      tokens.map(token => "{" + token + "}").join(".")
    } else { template }
    fill(pattern, (
      C: numbering(cr.numbering, nums.at(0)),
      S: if nums.len() > 1 { numbering(cr.numbering, nums.at(1)) } else { "" },
      B: if nums.len() > 2 { numbering(cr.numbering, nums.at(2)) } else { "" },
    ))
  }

  show ref: it => {
    let el = it.element
    if it.form != "normal" or it.supplement != auto or el == none or el.func() != heading or el.numbering == none or el.level > 3 {
      return it
    }
    let nums = counter(heading).at(el.location())
    let label = if is-appendix(el.numbering) {
      let num = numbering(el.numbering, ..nums.slice(0, el.level))
      s.appendix.at(0) + num + s.appendix.at(1)
    } else {
      let template = (cr.chapter, cr.section, cr.subsection).at(el.level - 1)
      cross-ref-format(template, nums)
    }
    link(el.location(), label)
  }

  let appendix-number(it, level) = {
    let nums = counter(heading).at(it.location()).slice(0, level + 1)
    let n = numbering(it.numbering, ..nums)
    if level == 0 { s.appendix.at(0) + n + s.appendix.at(1) } else { n }
  }

  // `sticky` keeps the heading on the same page as what follows it -- without
  // it, a heading can end up alone at the bottom of a page with its content
  // pushed to the next one
  let numbered(it, level, zh, en) = block(width: 100%, above: 0pt, below: 0pt, sticky: true, {
    set align(hd.align.at(level))
    set text(size: hd.size.at(level), weight: hd.weight)
    v(hd.gap-above.at(level))
    if it.numbering != none {
      if is-appendix(it.numbering) {
        appendix-number(it, level)
      } else {
        let n = counter(heading).at(it.location()).at(level)
        if l.language == "chinese" { zh(n) } else { en(n) }
      }
      h(hd.number-gap.at(level))
    }
    it.body
    v(hd.gap-below.at(level))
  })

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    if l.footnote-per-chapter { counter(footnote).update(0) }
    if l.equation-per-chapter { counter(math.equation).update(0) }
    numbered(
      it,
      0,
      n => s.chapter.at(0) + numbering("一", n) + s.chapter.at(1),
      n => s.chapter-en + " " + numbering("1", n),
    )
  }

  show heading.where(level: 2): it => numbered(
    it,
    1,
    n => s.section.at(0) + numbering("一", n) + s.section.at(1),
    n => s.section-en + " " + numbering("1", n),
  )

  show heading.where(level: 3): it => numbered(
    it,
    2,
    n => numbering("一", n) + s.subsection,
    n => numbering("1", n) + s.subsection,
  )

  show heading.where(level: 4): it => block(width: 100%, above: 0pt, below: 0pt, sticky: true, {
    set align(hd.align.at(3))
    set text(size: hd.size.at(3), weight: hd.weight)
    v(hd.gap-above.at(3))
    it.body
    v(hd.gap-below.at(3))
  })

  body
}
