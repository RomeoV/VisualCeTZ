#import "lib.typ": *

// Invisible box that reserves room for strokes wider than their path.
#let space(a, b) = "rect(" + repr(a) + ", " + repr(b) + ", stroke: none)\n"
// Hidden background grid from (x, y) to (w, h), as in Visual TikZ.
#let bg(w, h, x: 0, y: 0) = "grid((" + str(x) + ", " + str(y) + "), (" + str(w) + ", " + str(h) + "), stroke: 0.4pt + silver)\n"

= Paths and strokes <paths>

== Basic figures

=== Straight and perpendicular lines
#manual("basics/coordinate-systems#perpendicular", label: "perpendicular")
#examples(prelude: bg(2, 1),
  "line((0, 0), (2, 1), stroke: 2pt + blue)",
  "line((0, 0), ((), \"-|\", (2, 1)), (2, 1), stroke: 2pt + blue)",
  "line((0, 0), ((), \"|-\", (2, 1)), (2, 1), stroke: 2pt + blue)")

=== Stroke and fill
#manual("basics/styling", label: "styling")
#variants("bezier((0, 2), (2, 2), (3, 0), (-1, 0), VALUE)", (
  "stroke: 2pt + blue",
  "fill: eastern.lighten(60%), stroke: none",
  "fill: eastern.lighten(60%), stroke: 2pt + blue",
), columns: 3, prelude: bg(3, 2))

=== Bézier curves
#manual("api/draw-functions/shapes/bezier", label: "bezier")
#examples(prelude: bg(3, 2), length: 0.8cm,
  "bezier((0, 2), (2, 2), (3, 0), stroke: 2pt + blue)",
  "bezier((0, 2), (2, 2), (3, 0), (-1, 0), stroke: 2pt + blue)",
  "bezier-through((0, 0), (1, 2), (3, 1), stroke: 2pt + blue)",
  "catmull((0, 0), (1, 2), (2, 1), (3, 2), stroke: 2pt + blue)",
  "hobby((0, 0), (1, 2), (2, 1), (3, 2), stroke: 2pt + blue)")

=== Rectangle
#manual("api/draw-functions/shapes/rect", label: "rect")
#variants("rect((0.5, 0.5), (rel: (2, 1)), radius: VALUE, fill: green.lighten(60%), stroke: teal)",
  ("0", "0.3", "50%", "(north-east: 0.5)"), prelude: bg(3, 2))

=== Circle and ellipse
#manual("api/draw-functions/shapes/circle", label: "circle")
#variants("circle((1, 1), radius: VALUE, stroke: 2pt + blue)",
  ("1", "(2, 1)", "(1, 0.5)", "8mm"), prelude: bg(3, 2, x: -1))
#examples(prelude: bg(2, 2),
  "let (a, b, c) = ((0, 0), (2, 0), (1.5, 1.5))\ncircle-through(a, b, c, stroke: blue)\nfor p in (a, b, c) { circle(p, radius: 2pt, fill: red, stroke: none) }")

=== Arc
#manual("api/draw-functions/shapes/arc", label: "arc")
#variants("arc((-2, 0), start: 180deg, stop: -45deg, radius: 2, VALUE)", (
  "stroke: 2pt + blue",
  "fill: green.lighten(60%), stroke: none",
  "fill: green.lighten(60%), stroke: 2pt + blue",
), columns: 3, length: 0.6cm, prelude: bg(3, 2, x: -2, y: -2))
#variants("arc((0, 0), VALUE, stroke: 2pt + blue)", (
  "start: 180deg, stop: -45deg",
  "start: 180deg, delta: -225deg",
  "start: 180deg, stop: -45deg, radius: (1, 0.5)",
), columns: 3, prelude: bg(2, 1, y: -1))
#variants("arc((0, 0), start: 30deg, stop: 300deg, mode: VALUE, fill: green.lighten(60%), stroke: teal)",
  ("\"OPEN\"", "\"CLOSE\"", "\"PIE\""), columns: 3)

=== Parabola
#manual("api/draw-functions/shapes/bezier", label: "bezier")
#unported([`parabola`], [A quadratic `bezier` is a parabola. Its control point sets the bend.])
#variants("bezier((0, 0), (3, 2), VALUE, stroke: 2pt + blue)",
  ("(1.5, 0)", "(1.5, 2)", "(0, 2)"), columns: 3, prelude: bg(3, 2))
#examples(prelude: bg(3, 2),
  "// vertex at (1.5, 2): control point at twice the height
bezier((0, 0), (3, 0), (1.5, 4), stroke: 2pt + blue)")

=== Sine and cosine
#manual("api/draw-functions/shapes/line", label: "line")
#unported([`sin` and `cos` path operations], [Sample the function into a `line`, or use a plot library (#see(<plots>)).])
#examples(prelude: bg(3, 2),
  "let xs = range(17).map(i => i * calc.pi / 32)
line(..xs.map(x => (x, 2 * calc.sin(x))), stroke: 2pt + blue)",
  "let xs = range(17).map(i => i * calc.pi / 32)
line(..xs.map(x => (x, 2 - 2 * calc.cos(x))), stroke: 2pt + blue)")

=== Curved connections
#manual("api/draw-functions/shapes/bezier", label: "bezier")
#unported([`to[out=…, in=…]`], [Give a cubic `bezier` control points that leave and enter at the wanted angles, or let `hobby` find the curve.])
#examples(prelude: bg(3, 2),
  "// out = 0deg, in = 180deg
let (a, b) = ((0, 0), (3, 2))
bezier(a, b, (rel: (1.5, 0), to: a), (rel: (-1.5, 0), to: b), stroke: 2pt + blue)",
  "// out = 30deg, in = -90deg
let (a, b) = ((0, 0), (3, 2))
bezier(a, b, (rel: (30deg, 1.5), to: a), (rel: (0, -1.5), to: b), stroke: 2pt + blue)",
  "hobby((0, 0), (1.5, 1.4), (3, 2), stroke: 2pt + blue)")

=== Point lists
#manual("api/draw-functions/shapes/line", label: "line")
#examples(prelude: bg(5, 2), length: 0.8cm,
  "line((2, 0), (3, 1), (4, 1), (5, 2), stroke: 2pt + blue)",
  "let data = csv(bytes(\"0,0\\n1,1\\n1.5,0.5\\n2,2\\n3,1.5\"))
line(..data.map(r => r.map(float)), stroke: 2pt + blue)",
  "let xs = range(41).map(i => i / 8)
line(..xs.map(x => (x, 1 + calc.sin(1.3 * x))), stroke: 2pt + blue)")

== Paths

=== Open and closed
#manual("api/draw-functions/shapes/line", label: "line")
#variants("line((0, 0), (2, 1), (3, 0), close: VALUE, stroke: 2pt + blue)",
  ("false", "true"), columns: 2, prelude: bg(3, 1))
#examples(prelude: bg(2, 1),
  "line((0, 0), (2, 1), ((), \"-|\", (0, 0)), close: true, stroke: 2pt + blue)",
  "line((0, 0), (2, 1), ((), \"|-\", (0, 0)), close: true, stroke: 2pt + blue)")

=== Mixed segments
#manual("api/draw-functions/shapes/merge-path", label: "merge-path")
#examples(prelude: bg(8, 4), length: 0.6cm,
  "merge-path(fill: eastern.lighten(60%), stroke: 2pt + blue, {
  line((0, 0), (2, 1), (3, 3))
  arc((), start: 135deg, stop: -20deg, radius: 1)
  bezier((), (5, 2), (6, 0), (4, 0))
  catmull((), (6, 1), (7, 3))
})")

=== Rounded corners
#manual("api/draw-functions/shapes/rect", label: "rect")
#unported([`rounded corners` on arbitrary paths], [`rect` takes `radius` (see Rectangle). For other outlines, build each corner from `arc` segments inside `merge-path`.])
#examples(prelude: bg(2, 2),
  "merge-path(close: true, stroke: 2pt + blue, {
  line((0, 0), (1.5, 0))
  arc((), start: -90deg, stop: 90deg, radius: 0.5)
  line((), (0, 1))
})")

=== Repeated elements
#manual("api/draw-functions/shapes/circle", label: "circle")
#unported([`insert path`], [Loop over the points.])
#examples(prelude: bg(3, 2),
  "let pts = ((0, 0), (1, 2), (3, 1))
line(..pts, stroke: gray)
for p in pts { circle(p, radius: 3pt, stroke: red) }")

=== Interrupted paths
#manual("api/draw-functions/shapes/compound-path", label: "compound-path")
#examples(prelude: bg(3, 2),
  "compound-path(stroke: 2pt + blue, {
  line((0.5, 0.5), (2.5, 0.5))
  line((0.5, 1.5), (2.5, 1.5))
})")

=== Subpath start
#manual("basics/anchors#path", label: "path anchors")
#unported([`current subpath start`], [Name the element and use its `start` anchor.])
#examples(prelude: bg(4, 2),
  "line((0, 0), (0, 1), (1, 1), stroke: 2pt + blue)
line((2, 0), (2, 1), (3, 1), close: true, stroke: 2pt + blue, name: \"t\")
circle(\"t.start\", radius: 3pt, fill: red, stroke: none)")

=== Edges
#manual("api/draw-functions/shapes/line", label: "line")
#unported([`edge`], [Draw each branch as its own element from the shared point.])
#examples(prelude: bg(3, 2),
  "let v = (2, 1)
line((0, 0), v, (1, 2), (0, 1), stroke: 2pt + blue)
line(v, (3, 0), stroke: (paint: blue, thickness: 2pt, dash: \"dotted\"))
line(v, (3, 2), stroke: 2pt + red)")

== Strokes

=== Line width
#manual("api/draw-functions/styling/stroke", label: "stroke")
#variants("line((0, 0), (1, 1), stroke: VALUE + blue)",
  ("0.1pt", "0.2pt", "0.4pt", "0.6pt", "0.8pt", "1.2pt", "1.6pt", "0.2cm"))
#unported([named widths such as `thin` or `ultra thick`], [Give a length. TikZ's `ultra thin` to `ultra thick` are the first seven values above.])

=== Units
#manual("api/draw-functions/styling/stroke", label: "stroke")
#variants("line((0, 0), (0, 1), stroke: (thickness: VALUE, paint: blue))",
  ("10pt", "10mm", "0.5in", "1em", "0.3"), columns: 5, prelude: bg(1, 1, x: -1))
Typst's `pt` is TikZ's `bp`. A plain number is in canvas units. Typst has no `ex`.

=== Caps
#manual("api/draw-functions/styling/stroke", label: "stroke")
#variants("line((0, 0), (1.2, 0), stroke: (thickness: 12pt, cap: VALUE, paint: eastern))\nline((0, 0), (1.2, 0), stroke: 0.5pt + red)",
  ("\"butt\"", "\"square\"", "\"round\""), columns: 3, prelude: space((-0.3, -0.3), (1.5, 0.3)))

=== Joins
#manual("api/draw-functions/styling/stroke", label: "stroke")
#variants("line((0, 0), (1.2, 0.5), (0, 1), stroke: (thickness: 10pt, join: VALUE, paint: eastern))\nline((0, 0), (1.2, 0.5), (0, 1), stroke: 0.5pt + red)",
  ("\"miter\"", "\"bevel\"", "\"round\""), columns: 3, prelude: space((-0.2, -0.2), (1.7, 1.2)))
#variants("line((0, 0), (1.2, 0.3), (0, 0.6), stroke: (thickness: 10pt, miter-limit: VALUE, paint: eastern))\nline((0, 0), (1.2, 0.3), (0, 0.6), stroke: 0.5pt + red)",
  ("4", "5"), columns: 2, prelude: space((-0.2, -0.2), (1.9, 0.8)))
The default `miter-limit` is 4: this 28° corner needs about 4.1.

=== Dash styles
#manual("api/draw-functions/styling/stroke", label: "stroke")
#variants("line((0, 0), (2, 0.5), stroke: (thickness: 2pt, paint: blue, dash: VALUE))", (
  "\"dotted\"", "\"densely-dotted\"", "\"loosely-dotted\"",
  "\"dashed\"", "\"densely-dashed\"", "\"loosely-dashed\"",
  "\"dash-dotted\"", "\"densely-dash-dotted\"", "\"loosely-dash-dotted\"",
  "\"solid\"",
), columns: 3)
#unported([`dash dot dot`], [Give the pattern as an array, as below.])
#variants("line((0, 0), (4, 0), stroke: (thickness: 2pt, paint: blue, dash: VALUE))", (
  "(1cm, 0.25cm, 0.25cm, 0.5cm)",
  "(array: (1cm, 0.25cm, 0.25cm, 0.5cm), phase: 1cm)",
  "(4pt, 2pt, \"dot\", 2pt, \"dot\", 2pt)",
), columns: 1, prelude: bg(4, 0.5, y: -0.5))

=== Double lines
#manual("api/draw-functions/styling/stroke", label: "stroke")
#unported([`double`], [Stroke the path twice: wide, then narrow in the inner colour.])
#examples(
  "for s in (6pt + blue, 2pt + white) {
  line((0, 0), (2, 1), stroke: s)
}",
  "for s in (6pt + blue, 2pt + red) {
  line((0, 0), (2, 1), stroke: s)
}")

== Fills

=== Tilings
#manual("api/draw-functions/styling/fill", label: "fill")
#block(sticky: true)[Any Typst #link("https://typst.app/docs/reference/visualize/tiling/")[`tiling`] can fill a shape.]
#variants("rect((0, 0), (3, 1), fill: tiling(size: (6pt, 6pt), VALUE))", (
  "place(dx: 2pt, dy: 2pt, std.circle(radius: 1pt, fill: red))",
  "text(5pt, red, sym.star.filled)",
  "place(square(size: 3pt, fill: gray)) + place(dx: 3pt, dy: 3pt, square(size: 3pt, fill: gray))",
  "std.line(start: (0pt, 3pt), length: 6pt, stroke: blue)",
  "std.line(start: (3pt, 0pt), angle: 90deg, length: 6pt, stroke: blue)",
  "std.rect(width: 6pt, height: 6pt, stroke: 0.4pt + blue)",
  "std.line(start: (0pt, 6pt), end: (6pt, 0pt), stroke: blue)",
  "std.line(end: (6pt, 6pt), stroke: blue)",
  "place(std.line(end: (6pt, 6pt), stroke: blue)) + std.line(start: (0pt, 6pt), end: (6pt, 0pt), stroke: blue)",
), columns: 3)

=== Fill rule
#manual("basics/styling", label: "styling")
#variants("compound-path(fill-rule: \"non-zero\", fill: green.lighten(30%), stroke: teal, {
  line((0, 0), (0, 3), (3, 3), (3, 0), close: true)
  line(VALUE, close: true)
})", ("(1, 1), (1, 2), (2, 2), (2, 1)", "(1, 1), (2, 1), (2, 2), (1, 2)"), columns: 2, length: 0.6cm)
#variants("compound-path(fill-rule: VALUE, fill: green.lighten(30%), stroke: teal, {
  line((0, 0), (2, 1), (1, 2), close: true)
  circle((1, 2), radius: 0.5)
})", ("\"non-zero\"", "\"even-odd\""), columns: 2)

=== Filling with an image
#manual("api/draw-functions/styling/fill", label: "fill")
#unported([`path picture`], [Fill with a `tiling` whose single tile is the image, placed relative to the shape.])
#variants("let pic = tiling(relative: \"self\", size: (2cm, 2cm),
  image(\"/assets/picture.png\", width: 2cm, height: 2cm, fit: \"cover\"))
VALUE", (
  "circle((1, 1), radius: 1, fill: pic)",
  "line((1, 0), (2, 1), (1, 2), (0, 1), close: true, fill: pic)",
  "bezier((0, 0), (2, 0), (1, 4), fill: pic)",
), columns: 3)

=== Shading
#manual("api/draw-functions/styling/fill", label: "fill")
#block(sticky: true)[Any Typst #link("https://typst.app/docs/reference/visualize/gradient/")[`gradient`] can fill a shape.]
#variants("rect((0, 0), (3, 1), VALUE)", (
  "fill: gradient.linear(gray, white)",
  "fill: gradient.linear(gray, white), stroke: none",
), columns: 2)
#variants("rect((0, 0), (3, 1), fill: VALUE)", (
  "gradient.linear(gray, white)",
  "gradient.radial(gray, white)",
  "gradient.radial(white, blue, black, focal-center: (30%, 30%))",
  "gradient.linear(red, white)",
  "gradient.linear(white, green)",
  "gradient.linear(red, green)",
  "gradient.linear(red, white, angle: 90deg)",
  "gradient.linear(white, green, angle: 90deg)",
  "gradient.linear(gray, red, gray, angle: 90deg)",
  "gradient.linear(red, green, angle: 45deg)",
  "gradient.radial(red, white)",
  "gradient.radial(red, green)",
), columns: 3)
#examples(
  "rect((0, 0), (2, 2), fill: gradient.conic(..color.map.rainbow))",
  "rect((0, 0), (2, 2), fill: gradient.conic(..color.map.rainbow))
rect((0, 0), (2, 2), fill: gradient.radial(black, black.transparentize(100%)))",
  "rect((0, 0), (2, 2), fill: gradient.conic(..color.map.rainbow))
rect((0, 0), (2, 2), fill: gradient.radial(white, white.transparentize(100%)))")
#unported([four-corner shadings (`upper left`, …) and `Mandelbrot set`], [Typst gradients are linear, radial or conic. For one coloured corner, a diagonal gradient comes close.])
#examples("rect((0, 0), (2, 2), fill: gradient.linear(red, white, angle: 45deg))")
