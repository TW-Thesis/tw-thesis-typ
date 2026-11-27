// The thesis show rule: page flow from the cover to the main matter

#import "layout.typ": global-rules
#import "headings.typ": heading-rules
#import "front.typ": cover-page, verification-page
#import "outlines.typ": outline-rules, outlines, page-label

#let thesis(cfg, body) = {
  let l = cfg.layout
  let o = cfg.outline
  let pn = cfg.page-number

  // set by `just release`
  let watermark = sys.inputs.at("watermark", default: "false") == "true"

  // --- Global Settings ---
  set page(paper: l.paper, margin: l.margin)
  show: global-rules.with(cfg)
  show: heading-rules.with(cfg)

  // --- Cover Page ---
  cover-page(cfg)

  // --- Verification Letter ---
  pagebreak(weak: true)
  set page(margin: l.margin)
  verification-page(cfg)

  // --- TOC, LOF, LOT ---
  let label = page-label(cfg)
  pagebreak(weak: true)
  set page(
    numbering: o.page-numbering,
    header: if pn.position == "top" { label } else { [] },
    footer: if pn.position == "bottom" { label } else { [] },
  )
  counter(page).update(1)
  show: outline-rules.with(cfg)
  outlines(cfg)

  // --- Main Matter ---
  set page(
    numbering: o.body-numbering,
    background: if watermark and cfg.watermark.image != none {
      place(center + horizon, image(cfg.watermark.image, width: cfg.watermark.width))
      // the image itself carries no alpha, so wash it out with a white veil
      if cfg.watermark.opacity < 100% {
        place(rect(width: 100%, height: 100%, fill: white.transparentize(cfg.watermark.opacity)))
      }
    },
  )
  counter(page).update(1)

  body
}
