#import "lib.typ": *

= Groups, layers, and styles <structure>

// Rows of rendered markup | source, for arguments of `cetz.canvas` itself.
#let markup(..codes) = _table((1fr, 2fr),
  ..codes.pos().map(c => (pic(eval(c.trim(), mode: "markup", scope: scope)),
    table.cell(align: left, raw(c.trim(), lang: "typ")))).flatten())

// Like `examples`, but a dashed frame shows the canvas size.
#let framed(..codes) = _table((auto, 1fr), ..codes.pos().map(c => (
  pic(box(stroke: (paint: gray, thickness: 0.5pt, dash: "dashed"), render(c))),
  table.cell(align: left, _code(c)))).flatten())

// Several manual badges in one row, labelled by the last path segment.
#let manuals(..paths) = _badge-row(paths.pos().map(p => manual-badge(p, label: p.split("/").last())).join([ ]))

== Transformations
#manuals("api/draw-functions/transformations/rotate", "api/draw-functions/transformations/scale",
  "api/draw-functions/transformations/translate")
#variants("rect((0, 0), (2, 2), stroke: (paint: red, dash: \"dashed\"))\nVALUE\nrect((0, 0), (2, 2), stroke: blue)",
  ("rotate(40deg)", "scale(y: 50%)", "scale(1.5)", "scale(-1)",
   "translate(x: .5)", "translate(y: .5)", "rotate(40deg, origin: (1, 1))", "scale(50%, origin: (1, 1))"),
  length: 0.7cm)

=== Slant
#manual("api/draw-functions/transformations/set-transform", label: "set-transform")
#examples(
  "rect((0, 0), (2, 2), stroke: (paint: red, dash: \"dashed\"))
transform(cetz.matrix.transform-shear-x(.75))
rect((0, 0), (2, 2), stroke: blue)",
  "rect((0, 0), (2, 2), stroke: (paint: red, dash: \"dashed\"))
transform(((1, 0, 0, 0), (.75, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1)))
rect((0, 0), (2, 2), stroke: blue)",
  length: 0.7cm)

=== Order
Each call multiplies onto the current transform, so later calls act first on the drawn shape.
#examples(
  "rect((0, 0), (1, 1), stroke: (paint: red, dash: \"dashed\"))
translate(x: 2)
rotate(30deg)
rect((0, 0), (1, 1), stroke: blue)",
  "rect((0, 0), (1, 1), stroke: (paint: red, dash: \"dashed\"))
rotate(30deg)
translate(x: 2)
rect((0, 0), (1, 1), stroke: blue)")

=== New origin
#manuals("api/draw-functions/transformations/set-origin", "api/draw-functions/transformations/set-viewport")
#examples(
  "rect((0, 0), (2, 1), name: \"r\")
set-origin(\"r.north-east\")
circle((0, 0), radius: .15, fill: red)
rect((0, 0), (1, 1), stroke: blue)",
  "rect((0, 0), (2, 2), name: \"r\")
set-viewport(\"r.south-west\", \"r.north-east\", bounds: (10, 10))
circle((5, 5), radius: 3, stroke: blue)")

=== Axis vectors of the canvas
#manual("api/internal/canvas", label: "canvas")
#markup(
  "#cetz.canvas(x: 1, y: .5, {
  rect((0, 0), (2, 2), stroke: blue)
})",
  "#cetz.canvas(x: (1, 0), y: (.75, 1), {
  rect((0, 0), (2, 2), stroke: blue)
})")

== Placing the canvas
#manual("basics/canvas", label: "canvas")

=== In the text
Without `baseline`, a canvas is a block. With `baseline`, it is an inline box and the given $y$ (or coordinate) sits on the text baseline.
#markup(
  "text before #cetz.canvas(length: 5mm, {
  rect((0, 0), (2, 2), stroke: blue)
  circle((0, 0), stroke: red)
}) text after",
  "text before #cetz.canvas(length: 5mm, baseline: (0, 0), {
  rect((0, 0), (2, 2), stroke: blue)
  circle((0, 0), stroke: red)
}) text after",
  "text before #cetz.canvas(length: 5mm, baseline: (0, 1), {
  rect((0, 0), (2, 2), stroke: blue)
  circle((0, 0), stroke: red)
}) text after",
  "text before #cetz.canvas(length: 5mm, baseline: \"c.south\", {
  rect((0, 0), (2, 2), stroke: blue)
  circle((0, 0), stroke: red, name: \"c\")
}) text after",
  "text before #box(stroke: gray, inset: 3pt,
  cetz.canvas(length: 5mm, baseline: (0, 0), {
    rect((0, 0), (2, 2), stroke: blue)
    circle((0, 0), stroke: red)
  })) text after")

=== Bounding box
#manuals("api/draw-functions/grouping/hide", "api/draw-functions/grouping/floating")
Every element grows the canvas. `hide(.., bounds: true)` reserves space without drawing; `floating` draws without reserving space.
#framed(
  "rect((0, 0), (2, 1), stroke: red)
line((-1, 0), (3, 1), stroke: blue)",
  "rect((0, 0), (2, 1), stroke: red)
floating(line((-1, 0), (3, 1), stroke: blue))",
  "hide(rect((-1.5, -1.5), (2.5, 2.5)), bounds: true)
rect((0, 0), (2, 2), stroke: blue)
circle((0, 0), stroke: red)")

=== Current bounding box
#manual("api/draw-functions/shapes/rect-around", label: "rect-around")
#examples(
  "group(name: \"pic\", {
  circle((0, 0), radius: .15, fill: blue)
  circle((2, 1), radius: .15, fill: blue)
})
rect(\"pic.south-west\", \"pic.north-east\", stroke: red)",
  "circle((0, 0), radius: .15, fill: blue, name: \"a\")
circle((2, 1), radius: .15, fill: blue, name: \"b\")
rect-around(\"a\", \"b\", padding: .1, stroke: red)")

#unported([`trim left`, `trim right`], [Wrap parts that may stick out in `floating`.])

=== Clipping
#unported([`\clip`], [Clip the whole canvas with a Typst `box(clip: true)`; cut filled shapes with `boolean(.., op: "intersection")`.])
#markup(
  "#box(clip: true, width: 2.5cm, height: 2.5cm,
  align(center + horizon, cetz.canvas({
    grid((-2, -2), (2, 2), help-lines: true)
    for r in (.5, 1, 1.5) {
      circle((0, 0), radius: r, stroke: red)
    }
  })))")
#manual("api/draw-functions/shapes/boolean", label: "boolean")
#examples(
  "line((-1, -1), (0, 2), (1, -1), close: true, stroke: blue, name: \"t\")
for r in (.5, 1, 1.5) {
  boolean(\"t\", circle((0, 0), radius: r), op: \"intersection\",
    fill: red.transparentize(70%), stroke: red)
}")

=== Partial clipping
#manual("api/draw-functions/shapes/boolean", label: "boolean")
#examples(
  "rect((-1.1, -.2), (2, 1.5), stroke: blue, name: \"r\")
circle((0, 0), radius: 1.5, stroke: red)
boolean(\"r\", circle((0, 0), radius: 1), op: \"intersection\",
  fill: red.lighten(70%), stroke: red)")

=== Scaling
#manual("api/internal/canvas", label: "canvas")
#markup(
  "#cetz.canvas(length: 1cm, {
  grid((-2, -2), (2, 2), help-lines: true)
  for r in (.5, 1, 1.5) {
    circle((0, 0), radius: r, stroke: blue)
  }
})",
  "#cetz.canvas(length: 5mm, {
  grid((-2, -2), (2, 2), help-lines: true)
  for r in (.5, 1, 1.5) {
    circle((0, 0), radius: r, stroke: blue)
  }
})")

=== Absolute position on the page
#unported([`remember picture, overlay`, `current page` anchors], [Put the canvas in `#set page(background: ..)` or `foreground`, or position it with `place(top + right, dx: .., dy: .., ..)`.])

== Groups and scopes
#manual("api/draw-functions/grouping/scope", label: "scope")
#block(sticky: true)[Style and transform changes inside `scope` or `group` end with it.]
#examples(
  "grid((0, 0), (3, 6), help-lines: true)
set-style(stroke: (thickness: 3mm, paint: blue))
line((.5, 6), (2.5, 6))
scope({
  set-style(stroke: (paint: red))
  line((.5, 5), (2.5, 5))
  line((.5, 4), (2.5, 4))
})
line((.5, 3), (2.5, 3))
scope({
  set-style(stroke: (paint: teal))
  line((.5, 2), (2.5, 2))
  line((.5, 1), (2.5, 1), stroke: (paint: red))
  line((.5, 0), (2.5, 0))
})", length: 0.5cm)

=== Group or scope
#manual("api/draw-functions/grouping/group", label: "group")
A `group` is one element with bounding-box anchors; names inside it are reached through it. A `scope` leaks its names.
#examples(
  "group(name: \"g\", padding: .2, {
  circle((0, 0), radius: .4, fill: eastern.lighten(60%), name: \"a\")
  circle((1.5, .5), radius: .4, fill: eastern.lighten(60%), name: \"b\")
})
rect(\"g.south-west\", \"g.north-east\", stroke: (paint: red, dash: \"dashed\"))
line(\"g.a\", \"g.b\")",
  "scope({
  circle((0, 0), radius: .4, fill: eastern.lighten(60%), name: \"a\")
})
circle((1.5, .5), radius: .4, fill: eastern.lighten(60%), name: \"b\")
line(\"a\", \"b\", stroke: red)")

=== Placing a group by an anchor
The group moves so that the given anchor lands on its `"default"` anchor, here set to the origin.
#variants("group(anchor: VALUE, {
  anchor(\"default\", (0, 0))
  rect((0, 0), (2, 1), fill: eastern.lighten(60%))
})
circle((0, 0), radius: .1, fill: red)",
  ("\"south-west\"", "\"north-east\"", "\"center\"", "\"north\""), length: 0.8cm)

=== Layers
#manual("api/draw-functions/grouping/on-layer", label: "on-layer")
#examples(
  "content((1, 1), [CeTZ], frame: \"rect\", fill: white, padding: .1)
grid((0, 0), (3, 2), stroke: blue)",
  "content((1, 1), [CeTZ], frame: \"rect\", fill: white, padding: .1)
on-layer(-1, grid((0, 0), (3, 2), stroke: blue))")

== Background
=== Framing
#manual("api/internal/canvas", label: "canvas")
#markup(
  "#cetz.canvas(padding: .3,
  background: eastern.lighten(80%), stroke: 2pt + blue, {
  circle((0, 0), radius: (1, .5), fill: yellow)
})")
Inside the canvas, `rect-around` on a lower layer does the same and takes every `rect` style.
#manual("api/draw-functions/shapes/rect-around", label: "rect-around")
#variants("circle((0, 0), radius: (1, .5), fill: yellow, name: \"e\")
on-layer(-1, rect-around(\"e\", VALUE,
  fill: eastern.lighten(80%), stroke: 2pt + blue))",
  ("padding: (x: .5)", "padding: (y: .5)", "padding: .5", "padding: 0", "padding: .2", "padding: .2, radius: .2"),
  columns: 3)

=== Frame style
#variants("circle((0, 0), radius: (1, .5), fill: yellow, name: \"e\")
on-layer(-1, rect-around(\"e\", padding: .2, VALUE))",
  ("stroke: (paint: blue, dash: \"dashed\")", "stroke: 4pt + blue", "radius: .5, stroke: blue",
   "fill: aqua", "fill: gradient.linear(aqua, white, angle: 90deg)",
   "radius: (north-east: .4, south-west: .4), stroke: blue"),
  columns: 3)
#unported([`double` lines], [Draw two `rect-around` with different `padding`.])

=== Partial framing
#variants("group(name: \"g\", padding: .2,
  circle((0, 0), radius: (1, .5), fill: yellow))
line(VALUE, stroke: 2pt + blue)",
  ("\"g.north-west\", \"g.north-east\"", "\"g.south-west\", \"g.south-east\"",
   "\"g.south-west\", \"g.north-west\"", "\"g.south-east\", \"g.north-east\""),
  columns: 2)
#variants("group(name: \"g\", padding: .2,
  circle((0, 0), radius: (1, .5), fill: yellow))
line(\"g.south-west\", \"g.north-west\", VALUE)",
  ("stroke: 3pt + blue", "stroke: (paint: blue, dash: \"dotted\")",
   "mark: (symbol: \">\"), stroke: blue", "stroke: 8pt + blue"))
Lines past the corners: offset the ends with `rel`.
#variants("group(name: \"g\", padding: .2,
  circle((0, 0), radius: (1, .5), fill: yellow))
on-layer(-1, rect(\"g.south-west\", \"g.north-east\",
  fill: eastern.lighten(80%), stroke: 2pt + blue))
line(VALUE, stroke: 2pt + blue)",
  ("(rel: (-.5, 0), to: \"g.north-west\"), (rel: (.5, 0), to: \"g.north-east\")",
   "(rel: (0, .5), to: \"g.north-west\"), (rel: (0, -.5), to: \"g.south-west\")"),
  columns: 2)

=== Gridding
#manual("api/draw-functions/shapes/grid", label: "grid")
#variants("circle((0, 0), radius: (2, 1), fill: yellow)
on-layer(-1, grid((-2.5, -1.5), (2.5, 1.5), VALUE))",
  ("help-lines: true", "stroke: red", "step: .5, stroke: blue", "stroke: 1.5pt + blue"),
  columns: 2, length: 0.8cm)
#examples("circle((0, 0), radius: (2, 1), fill: yellow)
on-layer(-1, {
  rect((-2.5, -1.5), (2.5, 1.5),
    fill: eastern.lighten(80%), stroke: 2pt + blue)
  grid((-2.5, -1.5), (2.5, 1.5), step: .5, help-lines: true)
})", length: 0.8cm)

== Colors
=== Named colors
#typst-manual("visualize/color/", "color")
#variants("rect((0, 0), (1.6, .8), fill: VALUE)",
  ("black", "gray", "silver", "white", "navy", "blue", "aqua", "teal", "eastern",
   "purple", "fuchsia", "maroon", "red", "orange", "yellow", "olive", "green", "lime"),
  columns: 6)

=== Lighter and darker
#variants("rect((0, 0), (1.6, .8), fill: eastern.lighten(VALUE))",
  ("90%", "70%", "50%", "30%", "10%"), columns: 5)
#variants("rect((0, 0), (1.6, .8), fill: eastern.darken(VALUE))",
  ("10%", "30%", "50%", "70%", "90%"), columns: 5)

=== Mixing
#variants("rect((0, 0), (1.6, .8), fill: VALUE)",
  ("color.mix(red, eastern)", "color.mix(red, eastern, space: rgb)",
   "color.mix((red, 80%), (eastern, 20%))", "color.mix(red, eastern, black)"),
  columns: 2)

=== Defining a color
#variants("rect((0, 0), (1.6, .8), fill: VALUE)",
  ("rgb(75%, 50%, 25%)", "rgb(\"#bf8040\")", "luma(60%)",
   "cmyk(0%, 60%, 100%, 20%)", "oklch(65%, 0.12, 250deg)", "color.hsl(200deg, 60%, 50%)"),
  columns: 3)
#examples(
  "let tan = rgb(75%, 50%, 25%)
rect((0, 0), (2, 1), fill: tan)",
  "let pale = red.lighten(75%)
rect((0, 0), (2, 1), fill: pale)")

== Opacity
#typst-manual("visualize/color/#definitions-transparentize", "transparentize")
#variants("line((0, 0), (2, 1), stroke: 8pt + red)
line((0, 1), (2, 0), stroke: 8pt + eastern.transparentize(VALUE))",
  ("100%", "75%", "50%", "25%", "0%"), columns: 5)
#variants("rect((0, 0), (1, 1), fill: red, stroke: none)
rect((.5, 0), (1.5, 1), fill: eastern.transparentize(VALUE), stroke: none)",
  ("90%", "75%", "50%", "25%", "0%"), columns: 5)
#variants("content((0, 0), text(20pt, fill: blue.transparentize(VALUE))[text],
  frame: \"rect\", padding: .1)",
  ("0%", "25%", "50%", "75%", "100%"), columns: 5)
#unported([`opacity` for a whole element, named levels such as `semitransparent`], [Make each paint transparent with `transparentize`.])

=== Blend modes
#unported([`blend mode`, `blend group`], [Overlap transparent fills, or compute the result with `color.mix`.])
#examples("set-style(stroke: none)
circle((90deg, .6), fill: red.transparentize(50%))
circle((210deg, .6), fill: teal.transparentize(50%))
circle((330deg, .6), fill: eastern.transparentize(50%))")

=== Fading
#unported([`path fading`, `scope fading`, `\tikzfading`], [Fill with a Typst gradient whose stops are transparent.])
#variants("let c = blue
let t = c.transparentize(100%)
grid((-1, -1), (1, 1), step: .5, stroke: silver)
circle((0, 0), radius: 1, stroke: none, fill: VALUE)",
  ("gradient.linear(c, t, angle: 90deg)", "gradient.linear(t, c)", "gradient.linear(c, t, angle: 45deg)",
   "gradient.radial((c, 0%), (c, 70%), (t, 100%))",
   "gradient.radial((t, 0%), (t, 60%), (c, 80%), (t, 100%))",
   "gradient.radial(c, t, center: (30%, 30%))"),
  columns: 3)
#typst-manual("visualize/gradient/", "gradient")
#examples("let c = red
content((0, 0), text(28pt, weight: \"bold\",
  fill: gradient.linear(c, c.transparentize(100%)))[CeTZ],
  frame: \"rect\", stroke: blue, padding: .1)")

=== Transparency group
#unported([`transparency group`], [One path gets one opacity: put the parts in a `compound-path`.])
#examples(
  "grid((0, 0), (3, 3), help-lines: true)
set-style(stroke: 8mm + eastern.transparentize(50%))
line((.5, .5), (2.5, 2.5))
line((.5, 2.5), (2.5, .5))",
  "grid((0, 0), (3, 3), help-lines: true)
compound-path({
  line((.5, .5), (2.5, 2.5))
  line((.5, 2.5), (2.5, .5))
}, stroke: 8mm + eastern.transparentize(50%))", length: 0.7cm)

== Own commands
#typst-manual("foundations/function/", "function")
A Typst function that returns draw elements works like a TikZ command.
#examples(
  "let flag(pos) = group({
  set-origin(pos)
  for (i, c) in (blue, white, red).enumerate() {
    rect((i * .5, 0), (rel: (.5, 1)), fill: c)
  }
})
flag((0, 0))
flag((2, .5))",
  "let tag(pos, body) = content(pos, body,
  frame: \"rect\", fill: yellow, padding: .15)
tag((0, 0))[contents]
tag((2, 0))[more]")
#markup("#let flag = cetz.canvas(length: 3mm, baseline: (0, 0), {
  for (i, c) in (blue, white, red).enumerate() {
    rect((i, 0), (rel: (1, 1.5)), fill: c)
  }
})
The flag #flag sits in the text.")

== Own styles
#manual("api/draw-functions/styling/set-style", label: "set-style")
A style is a dictionary of named arguments; spread it with `..`.
#examples(
  "let mine = (stroke: 1.5pt + blue, fill: red.lighten(80%))
circle((0, 0), radius: 2, stroke: blue)
circle((0, 0), ..mine)",
  "let mine(c) = (stroke: c, fill: c.lighten(50%))
rect((0, 0), (2, 1), ..mine(red))
rect((3, 0), (5, 1), ..mine(eastern))",
  "let mine(c: gray) = (stroke: c, fill: c.lighten(50%))
rect((0, 0), (2, 1), ..mine())
rect((3, 0), (5, 1), ..mine(c: eastern))",
  length: 0.7cm)

=== Styles per element type
#manual("basics/styling", label: "styling")
#examples("set-style(stroke: blue,
  rect: (fill: eastern.lighten(70%)),
  circle: (fill: red.lighten(70%), stroke: (dash: \"dashed\")))
rect((0, 0), (1, 1))
circle((2, .5), radius: .5)
rect((3, 0), (4, 1))")

== Pictures in a canvas
#manual("api/draw-functions/shapes/content", label: "content")
=== In a content element
#examples("grid((0, 0), (5, 3), stroke: blue)
let flag = cetz.canvas(length: 2mm, {
  for (i, c) in (blue, white, red).enumerate() {
    rect((i, 0), (rel: (1, 1.5)), fill: c)
  }
})
content((1, 2), flag, frame: \"rect\", padding: .1,
  fill: teal.lighten(70%))
content((3.5, 1), image(\"/assets/picture.png\", width: 1cm),
  frame: \"rect\", fill: white, padding: .1)")

=== Image declared once
#typst-manual("visualize/image/", "image")
#examples("let cube = image(\"/assets/picture.png\", width: 3cm)
grid((0, 0), (5, 5), stroke: blue)
content((3, 2), cube)", length: 0.8cm)

== Freehand drawing
#unported([`random steps` decoration], [Jitter sampled points and draw a `catmull` curve through them, or a smooth `hobby` curve through hand-placed points.])
#manuals("api/draw-functions/shapes/catmull", "api/draw-functions/shapes/hobby")
#examples(
  "let pts = range(65).map(i => {
  let r = 1 + .05 * calc.fract(calc.sin(i) * 1e4) // jitter
  (2.5 * r * calc.cos(i * 5deg), 1.5 * r * calc.sin(i * 5deg))
})
catmull(..pts, stroke: red)",
  "line((0, 0), (5.5, 0), mark: (end: \">\"), stroke: blue)
line((0, 0), (0, 2.5), mark: (end: \">\"), stroke: blue)
hobby((0, 0), (1, 1), (2, 0), (3, 1), (4, 1), (5, 2),
  stroke: red)",
  "line((0, 0), (4.5, 0), mark: (end: \">\"), stroke: blue)
line((0, -1.2), (0, 1.5), mark: (end: \">\"), stroke: blue)
let pts = range(41).map(i => {
  let x = i / 10
  (x, calc.sin(x * 90deg) + .05 * calc.fract(calc.sin(i) * 1e4))
})
catmull(..pts, stroke: red)",
  length: 0.8cm)
