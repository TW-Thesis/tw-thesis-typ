// Cover page and verification letter

#import "util.typ": fill, month-name, pad2, roc-year, spread

#let cover-page(cfg) = {
  let s = cfg.strings
  let roc = y => roc-year(y, offset: s.era-offset)
  let cv = cfg.cover
  page(margin: cv.margin)[
    #set align(center)
    #set text(size: cv.size.org, weight: cv.weight.org)
    #cfg.university#cfg.college#cfg.institute \
    #cfg.degree#cfg.type \

    #v(cv.gap)
    #set text(size: cv.size.org-en, weight: cv.weight.org-en)
    #cfg.institute-en \
    #cfg.college-en \

    #v(cv.gap)
    #set text(size: cv.size.university-en, weight: cv.weight.university-en)
    #cfg.university-en \
    #cfg.degree-en #cfg.type-en \

    #v(cv.flex)
    #text(size: cv.size.title, weight: cv.weight.title)[#cfg.title] \
    #text(size: cv.size.title-en, weight: cv.weight.title-en)[#cfg.title-en] \

    #v(cv.flex)
    #set text(size: cv.size.author, weight: cv.weight.author)
    #cfg.author \
    #cfg.author-en \

    #v(cv.flex)
    #set text(size: cv.size.advisor, weight: cv.weight.advisor)
    #fill(cv.advisor-zh, (
      label: s.advisor-label, advisor: cfg.advisor, doctor: s.doctor,
    )) \
    #fill(cv.advisor-en, (
      label: s.advisor-label-en, advisor: cfg.advisor-en, doctor: s.doctor-en,
    )) \

    #v(cv.flex)
    #set text(size: cv.size.date, weight: cv.weight.date)
    #fill(cv.date-zh, (
      era: s.era,
      roc: roc(cfg.date.year),
      year-unit: s.year-unit,
      month: pad2(cfg.date.month),
      month-unit: s.month-unit,
    )) \
    #fill(cv.date-en, (
      month-name: month-name(cfg.date.month, s.months),
      year: cfg.date.year,
    ))
  ]
}

#let verification-page(cfg) = {
  let l = cfg.layout
  let s = cfg.strings
  let roc = y => roc-year(y, offset: s.era-offset)
  let sp = t => spread(t, gap: l.title-spread)
  let vf = cfg.verification
  let vg = vf.grid
  let rule-pair = grid(
    columns: (1fr, 1fr),
    column-gutter: vg.gutter,
    line(length: vg.rule-pair), line(length: vg.rule-pair),
  )
  [
    #set align(center)
    #set text(size: vf.size.university, weight: vf.weight.university)
    #fill(vf.degree-line, (
      university: cfg.university, institute: cfg.institute, degree: cfg.degree, type: cfg.type,
    )) \
    #set text(size: vf.size.title, weight: vf.weight.title)
    #sp(vf.title) \

    #v(vf.flex)
    #set text(size: vf.size.thesis-title, weight: vf.weight.thesis-title)
    #cfg.title \
    #cfg.title-en \

    #v(vf.flex)
    #set align(left)
    #set text(size: vf.size.body, weight: vf.weight.body)
    #set par(justify: l.justify, first-line-indent: l.first-line-indent)
    #fill(vf.statement, (
      author: cfg.author,
      id: cfg.id,
      university: cfg.university,
      institute: cfg.institute,
      degree: cfg.degree,
      type: cfg.type,
      roc: roc(cfg.oral-date.year),
      month: pad2(cfg.oral-date.month),
      day: pad2(cfg.oral-date.day),
    ))

    #v(vf.flex)
    #set align(center)
    #grid(
      columns: vg.columns,
      rows: vg.rows,
      align: (right + bottom, center + bottom),
      [#s.committee], [#line(length: vg.rule)],
      [], [#set align(center + horizon); #s.committee-advisor],
      [], rule-pair,
      [], rule-pair,
      [#s.director],
      [
        #h(vg.director-indent)
        #move(
          dx: vg.director-offset.at(0),
          dy: vg.director-offset.at(1),
          line(length: vg.rule-pair),
        )
      ],
    )
    #v(vf.flex-end)
  ]
}
