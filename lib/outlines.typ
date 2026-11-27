// Page labels and the table of contents, list of figures and list of tables

#import "util.typ": fill, spread, strip-footnotes
#import "headings.typ": is-appendix

// Keep page.numbering for outline entries; decorate only the header/footer.
#let page-label(cfg) = {
  let pn = cfg.page-number
  context {
    if page.numbering != none and pn.format != "" {
      align(pn.align, fill(pn.format, (
        page: numbering(page.numbering, ..counter(page).get()),
      )))
    }
  }
}

#let outline-rules(cfg, body) = {
  let l = cfg.layout
  let hd = l.heading
  let s = cfg.strings
  let o = cfg.outline

  // entries carry the same 第一章 / 第一節 label as the heading itself, not the
  // raw "1.1" the numbering pattern would give
  show outline.entry: it => {
    let el = it.element

    // rebuilding an entry drops the link typst puts on the default one
    let linked = body => link(el.location(), body)

    // a figure caption may carry a footnote; keep it out of the list of figures
    if el.func() == figure {
      let clean = strip-footnotes(el.caption.body)
      return linked(it.indented(
        it.prefix(),
        clean + h(0.3em) + box(width: 1fr, it.fill) + h(0.3em) + it.page(),
      ))
    }
    let prefix = if el.func() == heading and el.numbering != none {
      let n = counter(heading).at(el.location())
      if is-appendix(el.numbering) {
        let num = numbering(el.numbering, ..n.slice(0, it.level))
        if it.level == 1 { s.appendix.at(0) + num + s.appendix.at(1) } else { num }
      } else if l.language != "chinese" {
        it.prefix()
      } else if it.level == 1 {
        s.chapter.at(0) + numbering("一", n.at(0)) + s.chapter.at(1)
      } else if it.level == 2 {
        s.section.at(0) + numbering("一", n.at(1)) + s.section.at(1)
      } else {
        numbering("一", n.at(it.level - 1)) + s.subsection
      }
    } else { it.prefix() }

    let entry = linked(it.indented(prefix, it.inner(), gap: hd.number-gap.at(it.level - 1)))
    if it.level == 1 {
      v(o.entry-gap, weak: true)
      if o.entry-bold { strong(entry) } else { entry }
    } else { entry }
  }

  body
}

#let outlines(cfg) = {
  let o = cfg.outline
  let sp = t => spread(t, gap: cfg.layout.title-spread)
  outline(title: text(size: o.title-size)[#sp(cfg.titles.toc)], depth: o.depth, indent: o.indent)
  pagebreak(weak: true)
  outline(title: text(size: o.title-size)[#sp(cfg.titles.lof)], target: figure.where(kind: image))
  pagebreak(weak: true)
  outline(title: text(size: o.title-size)[#sp(cfg.titles.lot)], target: figure.where(kind: table))
}
