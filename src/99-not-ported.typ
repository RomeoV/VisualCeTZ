#import "lib.typ": *

= Not ported <not-ported>

#let universe(name) = link("https://typst.app/universe/package/" + name, raw(name))
// Picture over its source; `src` is Typst markup and may import packages.
#let demo(src) = vstack(spacing: 6pt,
  pic(eval(src, mode: "markup", scope: (:))), raw(src, lang: "typ", block: true))
#let code(src) = raw(src, lang: "typ", block: true)

Visual TikZ sections without a CeTZ counterpart. Single options that CeTZ lacks are marked _Not in CeTZ_ in their own chapters.

#table(columns: (8em, 11em, 1fr), stroke: 0.5pt + rule, inset: 5pt, align: left + horizon,
  table.header([*Visual TikZ*], [*Instead*], [*Example*]),

  [*7.14–7.16* Matrices, chains],
  table.cell(colspan: 2)[Loops that place and name elements; a Typst `table` or `mat` inside one `content`. #see(<content>)],

  [*11* Absolute position on a page],
  [Typst `page(background:)` or `foreground:` with `place`; #universe("pinit") to point at text. #see(<structure>)],
  code("#import \"@preview/cetz:0.5.2\": canvas, draw
#set page(background: place(top + right,
  dx: -1cm, dy: 1cm, canvas({
    draw.circle((0, 0), fill: red)
  })))"),

  [*14* Blend modes, fadings, transparency groups],
  table.cell(colspan: 2)[Transparent paints and gradient stops; `color.mix` for a blended colour. #see(<structure>)],

  [*17.7* Multi-part shapes],
  table.cell(colspan: 2)[A Typst `table` inside `content`, or a shape split with a `line`. #see(<shapes>)],

  [*18.4–18.7* Footprint, shape, text and fractal decorations],
  table.cell(colspan: 2)[Loops over path anchors; recursive point functions. #see(<decorations>)],

  [*20* Freehand drawing],
  [`hobby` or `catmull` through jittered points (#see(<structure>)); #universe("scrawl") for a sketched look],
  demo("#import \"@preview/scrawl:0.1.0\": *
#scrawl-ellipse(paint: red)[freehand]
#scrawl-box(paint: blue)[box]"),

  [*21.1* `tikzpeople`],
  [#universe("pixel-family")],
  demo("#import \"@preview/pixel-family:0.2.1\": *
#alice(size: 1.2cm)
#bob(size: 1.2cm, shirt: aqua)"),

  [*21.2* `tikzducks`],
  [#universe("figchild"): 561 CeTZ figures; `emoji.duck`],
  demo("#import \"@preview/figchild:0.1.0\": *
#stack(dir: ltr, spacing: 5mm,
  canvas(fc-duck(scale: .4)),
  canvas(fc-duck-a(scale: .4, fill: orange)),
  canvas(fc-duck-b(scale: .4, stroke: blue)))"),

  [*21.3* `tikzsymbols`],
  [Built-in `emoji` and `sym` modules],
  demo("#text(20pt)[#emoji.face.smile #emoji.cooking
  #emoji.teapot #emoji.knife #sym.suit.heart]"),

  [*22.3* gnuplot],
  table.cell(colspan: 2)[Sample with `calc`, or read precomputed data with `csv`. #see(<plots>)],

  [*25* Variation tables (`tkz-tab`)],
  [#universe("functable")],
  demo("#import \"@preview/functable:0.2.0\": sign-table
#sign-table(
  factors: ((expr: $2x$, fn: x => 2 * x,
    zeros: ((value: $0$, approx: 0),)),),
  summary-label: $f'(x)$,
  variation: true, variation-label: $x^2$,
  start-value: $+oo$, end-value: $+oo$,
  variation-values: ((at: 0, label: $0$),),
)"),

  [*27* Turtle graphics],
  table.cell(colspan: 2)[Relative polar steps in one `line`. #see(<loops-trees>)],

  [*29* Electrical circuits],
  [#universe("zap"), built on CeTZ 0.5.2],
  demo("#import \"@preview/zap:0.6.0\"
#zap.circuit({
  import zap: *
  vsource(\"v\", (0, 0), (0, 2))
  resistor(\"r\", (0, 2), (3, 2), label: $R$)
  capacitor(\"c\", (3, 2), (3, 0), label: $C$)
  wire((3, 0), (0, 0))
})"),

  [*30* Logic circuits],
  [#universe("zap") gates, IEC or IEEE; #universe("circuiteria") (pins CeTZ 0.3.4) for block circuits],
  demo("#import \"@preview/zap:0.6.0\"
#zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: (variant: \"ieee\"))
  land(\"a\", (0, 0))
  lor(\"b\", (0, -1.5))
  lnand(\"c\", (2.5, -.75))
  zwire(\"a.out\", \"c.in1\")
  zwire(\"b.out\", \"c.in2\")
})"),

  [*31* Optics],
  [#universe("beam") (pins CeTZ 0.4.2), #universe("laserly")],
  demo("#import \"@preview/beam:0.1.1\"
#beam.setup({
  import beam: *
  laser(\"l\", (0, 0))
  lens(\"f\", (1, 0))
  detector(\"d\", (2, 0))
  beam(\"\", \"l\", \"f\")
  focus(\"\", \"f\", \"d\")
})"),

  [*32* Animation (`animate`)],
  [One page per frame, exported as PNG images; #universe("touying") or #universe("polylux") for slide overlays; #universe("kino")],
  code("// typst compile --format png anim.typ 'f-{0p}.png'
#import \"@preview/cetz:0.5.2\": canvas, draw
#set page(width: 3cm, height: 3cm, margin: 0pt)
#set align(center + horizon)
#for t in range(24) {
  page(canvas({
    draw.rotate(t * 15deg)
    draw.rect((-1, -1), (1, 1))
  }))
}"),
)
