// Figure helpers: one image, images side by side, or images in a grid.
// Each takes a path or ready-made content, so `image` options still work.
//
//   #fig("/figures/samples/architecture.png", caption: [研究架構], width: 60%) <fig:one>
//   #fig-row(caption: [函數圖形], ("/figures/samples/sin-x.pdf", [$sin x$]), ("/figures/samples/x-sin-x.pdf", [$x sin x$])) <fig:row>
//   #fig-grid(rows: 2, columns: 2, caption: [2x2], ..items) <fig:grid>

#let sub-numbering = "(a)"

#let as-image(src, width: 100%) = if type(src) == str {
  image(src, width: width)
} else { src }

#let fig(src, caption: none, width: 80%, supplement: auto, placement: none) = figure(
  as-image(src, width: width),
  caption: caption,
  supplement: supplement,
  placement: placement,
)

// items are (source, sub-caption) pairs; the sub-caption may be omitted
#let sub-cell(item, index, width: 100%) = {
  let (src, sub) = if type(item) == array { (item.at(0), item.at(1, default: none)) } else {
    (item, none)
  }
  align(center)[
    #as-image(src, width: width)
    #if sub != none [
      #v(0.3em)
      #text(size: 0.95em)[#numbering(sub-numbering, index + 1) #sub]
    ]
  ]
}

#let fig-grid(
  rows: auto,
  columns: 2,
  caption: none,
  gutter: 1em,
  row-gutter: 0.8em,
  width: 100%,
  supplement: auto,
  placement: none,
  ..items,
) = {
  assert(type(columns) == int and columns > 0, message: "columns must be a positive integer")
  assert(rows == auto or (type(rows) == int and rows > 0), message: "rows must be a positive integer or auto")

  let cells = items.pos().enumerate().map(((i, item)) => sub-cell(item, i, width: width))
  if rows != auto {
    assert(cells.len() <= rows * columns, message: "fig-grid has more images than rows * columns")
    cells += range(rows * columns - cells.len()).map(_ => [])
  }

  figure(
    grid(
      rows: if rows == auto { () } else { range(rows).map(_ => auto) },
      columns: columns,
      column-gutter: gutter,
      row-gutter: row-gutter,
      align: horizon,
      ..cells,
    ),
    caption: caption,
    kind: image,
    supplement: supplement,
    placement: placement,
  )
}

// side by side is a grid with one row
#let fig-row(caption: none, gutter: 1em, width: 100%, supplement: auto, placement: none, ..items) = fig-grid(
  columns: items.pos().len(),
  caption: caption,
  gutter: gutter,
  width: width,
  supplement: supplement,
  placement: placement,
  ..items,
)
