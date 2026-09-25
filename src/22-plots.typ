#import "lib.typ": *
#import "@preview/lilaq:0.6.0" as lq

// Shared snippet setup, shown once and passed as `prelude:` to the tables after it.
#let setup(code) = block(sticky: true, width: 100%, fill: silver.lighten(60%), inset: 6pt, radius: 2pt, _code(code))

// Rows of lilaq figure | code. A lilaq diagram is content, not a canvas body, so `render` cannot draw it.
#let lilaq(..codes) = _table((auto, 1fr), ..codes.pos().map(c => (
  pic(eval(c, mode: "code", scope: (lq: lq))), table.cell(align: left, _code(c)))).flatten())

= Plots <plots>

CeTZ has no `plot` command. Sample with Typst arrays, then draw with `line`, `catmull` or `hobby`;
place data marks with `mark`. For data plots with real axes, use lilaq (@lilaq).

== Graphs from points and functions

=== From a list of points
#manual("api/draw-functions/shapes/line", label: "line")
#examples("line((0, 0), (1, 1), (2, 0), (3, 1), (4, 1), (5, 2), stroke: blue)")

=== From data <plot-data>
#manual("api/draw-functions/shapes/catmull", label: "catmull")
#let data = ```
// From a file: let pts = csv("table.csv").map(row => row.map(float))
let pts = ((0, .3), (.3, .6), (.6, .9), (.9, 1.5), (1.2, .6), (1.5, 1.2), (1.8, 1.5), (2.1, 2), (2.4, 3))
set-style(stroke: blue, mark: (anchor: "center", fill: red, stroke: red))
```.text + "\n"
#setup(data)
#variants("VALUE\nfor p in pts { mark(p, 0deg, \"x\") }",
  ("line(..pts)", "catmull(..pts)", "catmull(..pts, tension: .3)", "catmull(..pts, tension: 1)", "hobby(..pts)"),
  columns: 5, prelude: data)

=== Plot types <plot-types>
#manual("api/draw-functions/shapes/rect", label: "rect")
#variants(```
for ((x0, y0), (x1, y1)) in pts.windows(2) {
  VALUE
}
for p in pts { mark(p, 0deg, "o", scale: .6) }
```.text, (
  "line((x0, y0), (x1, y0), (x1, y1))",
  "line((x0, y0), (x0, y1), (x1, y1))",
  "line((x0, y0), ((x0 + x1) / 2, y0), ((x0 + x1) / 2, y1), (x1, y1))",
  "line((x0, y0), (x1, y0))",
  "line((x0, y1), (x1, y1))",
  "rect((x0, 0), (x1, y0))",
  "rect((0, y0), (x0, y1))",
  "// only marks",
), prelude: data)
#variants(```
for (x, y) in pts {
  VALUE
}
for p in pts { mark(p, 0deg, "o", scale: .6) }
```.text, (
  "line((x, 0), (x, y))",
  "line((0, y), (x, y))",
  "rect((x - .1, 0), (x + .1, y))",
  "rect((0, y - .05), (x, y + .05))",
), prelude: data)
#examples(```
for (a, r) in ((0deg, 1), (60deg, .5), (120deg, 1.5), (180deg, 2), (240deg, .5), (300deg, 1)) {
  line((0, 0), (a, r))
  mark((a, r), 0deg, "o", scale: .6)
}
```.text, ```
let a = (1, 1.2, .6, .7, .9)
let b = (1.2, 1.3, .5, .2, .5)
for (i, (y, z)) in a.zip(b).enumerate() {
  rect((i, 0), (rel: (.3, y)), fill: eastern.lighten(60%))
  rect((i + .3, 0), (rel: (.3, z)), fill: red.lighten(70%), stroke: red)
}
```.text, prelude: data)

=== Graph of a function
#manual("api/draw-functions/shapes/line", label: "line")
#variants(```
line((0, 0), (6.6, 0), mark: (end: ">"))
line((0, -1.2), (0, 1.6), mark: (end: ">"))
line(..range(64).map(i => i / 10).map(x => VALUE), stroke: red)
```.text, ("(x, x / 4)", "(x, calc.sin(x))", "(x, calc.sin(x * 90deg))"), columns: 3, length: .7cm)
#variants(```
let f(x) = calc.sin(x)
line(..range(64).map(i => i / 10).map(x => (x, f(x))), stroke: (paint: red, dash: "dashed"))
let xs = VALUE
line(..xs.map(x => (x, f(x))), stroke: 1.5pt + blue)
for x in xs { mark((x, f(x)), 0deg, "o", scale: .6) }
```.text, ("range(5).map(i => 1.5 * i)", "range(9).map(i => i / 2)", "range(9).map(i => 1 + i / 2)", "(1, 2, 4, 5)"),
  columns: 2, prelude: data)

=== Parametric curves
#manual("api/draw-functions/projections/ortho", label: "ortho")
#examples(```
let ts = range(101).map(i => i / 100 * 2 * calc.pi)
line(..ts.map(t => (calc.sin(t), calc.sin(2 * t))), stroke: 1pt)
```.text, ```
ortho(line(..range(0, 721, step: 10).map(t =>
  (calc.sin(t * 1deg), t / 360, calc.cos(t * 1deg))), stroke: 1pt))
```.text, prelude: data)

== Marks on data points
#manual("basics/marks", label: "marks")
`mark(pos, angle, symbol)` draws one mark; `anchor: "center"` (set in the setup) centres it on `pos`.
Marks keep their size under `scale`; circles do not. Arrow tips: #see(<marks>).

=== Mark symbols
#manual("api/draw-functions/shapes/mark", label: "mark")
#variants("line((0, 0), (1, .8), (2, 0))\nfor p in ((0, 0), (1, .8), (2, 0)) { mark(p, 0deg, VALUE, scale: 1.5) }",
  ("\"o\"", "\"[]\"", "\"<>\"", "\">\"", "\"+\"", "\"x\"", "\"*\"", "\"|\""), prelude: data)

=== Mark style
#manual("basics/marks", label: "marks")
#variants("line((0, 0), (1, .8), (2, 0))\nfor p in ((0, 0), (1, .8), (2, 0)) { mark(p, VALUE) }",
  ("0deg, \"o\"", "0deg, \"o\", fill: none", "0deg, \"o\", scale: 2.5", "0deg, \"o\", fill: aqua",
   "0deg, \"[]\", scale: 1.5", "90deg, \"|\", scale: 1.5", "0deg, \"+\", scale: 2", "45deg, \"+\", scale: 2"),
  prelude: data)

=== Shapes as marks
#manual("api/draw-functions/shapes/n-star", label: "n-star")
#variants("line((0, 0), (1, .8), (2, 0))\nfor p in ((0, 0), (1, .8), (2, 0)) { VALUE }", (
  "circle(p, radius: .12, fill: red)",
  "polygon(p, 3, radius: .15, angle: 90deg)",
  "polygon(p, 5, radius: .15, angle: 90deg, fill: red)",
  "n-star(p, 5, radius: .17, inner-radius: 45%, fill: red)",
  "n-star(p, 10, radius: .17, inner-radius: 40%)",
  "n-star(p, 6, radius: .17, show-inner: true)",
  "n-star(p, 3, radius: .17, inner-radius: 0%, angle: 90deg)",
  "n-star(p, 3, radius: .17, inner-radius: 0%, angle: -90deg)",
  "arc(p, start: 0deg, stop: 180deg, radius: .15, mode: \"CLOSE\", anchor: \"origin\", fill: red)",
  "circle(p, radius: .15, fill: gradient.linear(white, red, angle: 90deg).sharp(2))",
  "polygon(p, 4, radius: .17, fill: gradient.linear(red, white).sharp(2))",
  "circle(p, radius: .15, stroke: none, fill: gradient.radial(white, blue, focal-center: (30%, 30%)))",
), prelude: data)

=== Text marks
#manual("api/draw-functions/shapes/content", label: "content")
#variants("line((0, 0), (1, .8), (2, 0))\nfor p in ((0, 0), (1, .8), (2, 0)) { content(p, VALUE) }", (
  "[A]", "[Text]", "text(red)[♥]", "$plus.o$",
  "$times.o$", "emoji.tiger", "[88], frame: \"rect\", padding: .05, fill: white", "text(8pt)[#p.at(0)]",
), prelude: data)

=== Which points get a mark
#manual("api/draw-functions/shapes/mark", label: "mark")
#variants(```
let pts = range(21).map(i => (i / 5, calc.sin(i * 18deg)))
line(..pts)
for i in VALUE { mark(pts.at(i), 0deg, "o", scale: .6) }
```.text, ("range(21)", "range(0, 21, step: 3)", "range(2, 21, step: 3)", "(1, 4, 7, 10, 13, 15, 17, 20)"),
  prelude: data)

== Graphs from gnuplot
#unported[`plot function` through gnuplot][Typst cannot run programs. Compute samples with `calc`, or run gnuplot (or Python) once and read its table with `csv`.]

== Axes in the style of pgfplots
#let axes = data + ```
let f(x) = x * x - x + 4
let axes(xs, ys) = {
  let (x0, x1, y0, y1) = (xs.first(), xs.last(), ys.first(), ys.last())
  rect((x0, y0), (x1, y1), name: "frame", stroke: gray)
  for x in xs { content((x, y0), text(7pt)[#x], anchor: "north", padding: 3pt) }
  for y in ys { content((x0, y), text(7pt)[#y], anchor: "east", padding: 3pt) }
}
```.text + "\n"
CeTZ has no axis object: `scale` maps data units to the canvas, a loop writes the tick labels.
The setup below extends the one of @plot-data.
#setup(axes.slice(data.len()))

=== Axes
#manual("api/draw-functions/transformations/scale", label: "scale")
#unported[Logarithmic axes (`semilogxaxis`, `loglogaxis`)][Map the data with `calc.log(x)` and label ticks $10^k$, or use lilaq with `xscale: "log"` (@lilaq).]
#examples(```
scale(x: .25, y: .06)
axes(range(-6, 7, step: 2), range(0, 41, step: 10))
line(..range(-5, 6).map(x => (x, f(x))))
```.text, prelude: axes)

=== Domain and samples
#manual("api/draw-functions/shapes/line", label: "line")
#unported[Clipping to the axis window (`xmin`, `ymax`)][Restrict the samples instead: `pts.filter(((x, y)) => y <= 20)`. lilaq clips to `xlim` and `ylim`.]
#variants(```
scale(x: .25, y: .06)
axes(range(-6, 7, step: 3), range(0, 41, step: 10))
let pts = VALUE.map(x => (x, f(x)))
line(..pts)
for p in pts { mark(p, 0deg, "o", scale: .5) }
```.text, ("range(-5, 6)", "range(-4, 13).map(i => i / 4)", "range(5).map(i => -5 + 2.5 * i)", "range(-1, 4)"),
  prelude: axes)

=== Units and size
#manual("api/draw-functions/transformations/scale", label: "scale")
#variants(```
scale(VALUE)
axes(range(-6, 7, step: 6), range(0, 41, step: 20))
line(..range(-5, 6).map(x => (x, f(x))))
```.text, ("x: .25, y: .06", "x: .1, y: .06", "x: .25, y: .03", "x: .1, y: .03"), prelude: axes)

=== More plot types
#manual("api/draw-functions/shapes/line", label: "line")
Steps, combs and bars: @plot-types.
#examples(```
let c = gradient.linear(..color.map.viridis)
for (x, y) in pts { mark((x, y), 0deg, "o", fill: c.sample(y / 3 * 100%), stroke: none) }
```.text, ```
for x in range(-2, 3) {
  for y in range(-2, 3) {
    line((x / 2, y / 2), (rel: (-y / 5, x / 5)), mark: (end: ">", anchor: "tip", scale: .6))
  }
}
```.text, prelude: data)
#examples(```
let top = pts.map(((x, y)) => (x, 2 * y))
line((0, 0), ..pts, (2.4, 0), close: true, fill: eastern.lighten(60%))
line(..pts, ..top.rev(), close: true, fill: red.lighten(70%), stroke: red)
```.text, ```
for (x, y) in pts {
  rect((x - .1, 0), (x + .1, y), fill: eastern.lighten(60%))
  rect((x - .1, y), (x + .1, 2 * y), fill: red.lighten(70%), stroke: red)
}
```.text, length: .6cm, prelude: data)

=== Error bars
#manual("basics/marks", label: "marks")
#variants("line(..pts)\nfor (x, y) in pts {\n  VALUE\n}", (
  "line((x, y - .3), (x, y + .3), mark: (symbol: \"|\"))",
  "line((x, y), (x, y + .3), mark: (end: \"|\"))",
  "line((x, y - .3), (x, y), mark: (start: \"|\"))",
  "line((x, .8 * y), (x, 1.2 * y), mark: (symbol: \"|\"))",
  "line((x - .1, y), (x + .1, y), mark: (symbol: \"|\"))",
  "rect((x - .05, y - .2), (x + .05, y + .2))",
), columns: 3, prelude: data)

=== Labels and title
#manual("basics/anchors", label: "anchors")
#variants(```
rect((0, 0), (2.4, 3), name: "frame")
line(..pts)
VALUE
```.text, (
  "content(\"frame.south\", [$x$ label], anchor: \"north\", padding: .1)",
  "content(\"frame.west\", [$y$ label], angle: 90deg, anchor: \"south\", padding: .1)",
  "content(\"frame.north\", [*Title*], anchor: \"south\", padding: .1)",
), columns: 3, prelude: data)

=== Legend
#manual("api/draw-functions/shapes/content", label: "content")
#let legend = data + ```
rect((0, 0), (3, 2), name: "frame", stroke: gray)
let hues = (blue, red, teal)
for (i, c) in hues.enumerate() {
  line(..range(13).map(k => (k / 4, calc.pow(k / 4 - 1.5, 2) / 2 + .3 * i)), stroke: c)
}
let keys = hues.zip(($x^2$, [f(x)], [a curve])).map(((c, b)) => [#text(c)[—] #b])
```.text + "\n"
The legend is Typst content: a `std.grid` (`grid` is CeTZ's) inside a framed `content` element.
#setup(legend.slice(data.len()))
#variants("content(VALUE, std.grid(gutter: 3pt, ..keys), frame: \"rect\", fill: white, padding: .1)", (
  "\"frame.north-east\", anchor: \"north-east\"",
  "\"frame.center\", anchor: \"center\"",
  "\"frame.east\", anchor: \"west\"",
), columns: 3, prelude: legend)
#variants("content(\"frame.north-east\", VALUE, anchor: \"north-east\", frame: \"rect\", fill: white, padding: .1)", (
  "std.grid(columns: 2, gutter: 3pt, ..keys)",
  "std.grid(columns: 3, gutter: 3pt, ..keys)",
  "std.grid(align: right, gutter: 3pt, ..keys)",
  "text(6pt, std.grid(gutter: 3pt, ..keys))",
), columns: 2, prelude: legend)

=== Grids
#manual("api/draw-functions/shapes/grid", label: "grid")
#variants(```
VALUE
rect((0, 0), (2.4, 3))
line(..pts)
```.text, (
  "grid((0, 0), (2.4, 3), step: .6, stroke: silver)",
  "grid((0, 0), (2.4, 3), step: (x: .6, y: 3), stroke: silver)",
  "grid((0, 0), (2.4, 3), step: (x: 2.4, y: .5), stroke: silver)",
), columns: 3, prelude: data)

=== Values at data points
#manual("api/draw-functions/shapes/content", label: "content")
#examples(```
line(..pts)
for (x, y) in pts {
  mark((x, y), 0deg, "o", scale: .5)
  content((x, y), text(7pt)[#y], anchor: "south-east", padding: .05)
}
```.text, ```
scale(x: .25, y: .06)
axes(range(-6, 7, step: 3), range(0, 41, step: 10))
let pts = range(-5, 6, step: 2).map(x => (x, f(x)))
line(..pts)
for (x, y) in pts {
  mark((x, y), 0deg, "o", scale: .5)
  content((x, y), text(7pt)[#y], anchor: "south", padding: 3pt)
}
```.text, prelude: axes)

== 3D graphs
#manual("api/draw-functions/projections/ortho", label: "ortho")
`ortho(x: -60deg, y: 0deg, z: -30deg)` puts the $z$ axis up; `x:` sets the elevation, `z:` the azimuth.
`sorted: true` (default) draws far faces first.
#let surf = ```
let surface(f, n: 8, map: color.map.viridis, mesh: false, stroke: .3pt) = {
  let g = range(n + 1).map(i => -1 + 2 * i / n)
  let c = gradient.linear(..map)
  for (x0, x1) in g.windows(2) {
    for (y0, y1) in g.windows(2) {
      let q = ((x0, y0), (x1, y0), (x1, y1), (x0, y1)).map(((x, y)) => (x, y, f(x, y)))
      let paint = c.sample((q.map(p => p.at(2)).sum() / 4 + 1) * 50%)
      line(..q, close: true, fill: if mesh { none } else { paint },
        stroke: if mesh { paint } else { stroke })
    }
  }
}
```.text + "\n"
#setup(surf)

=== Axes and frame
#manual("api/draw-functions/projections/on-xy", label: "on-xy")
#variants(```
ortho(x: -60deg, y: 0deg, z: -30deg, {
  scale(VALUE)
  on-layer(-1, {
    on-xy(z: -1, grid((-1, -1), (1, 1), step: .5, stroke: silver))
    on-xz(y: 1, grid((-1, -1), (1, 1), step: .5, stroke: silver))
    on-zy(x: -1, grid((-1, -1), (1, 1), step: .5, stroke: silver))
  })
  surface((x, y) => y)
})
```.text, ("x: 1", "x: 2", "y: 2", "z: 2"), length: .8cm, prelude: surf)
#examples(```
ortho(x: -60deg, y: 0deg, z: -30deg, {
  surface((x, y) => -x * y)
  for (p, l) in (((1.6, 0, 0), $x$), ((0, 1.6, 0), $y$), ((0, 0, 1.6), $z$)) {
    line((0, 0, 0), p, mark: (end: ">"), stroke: 1pt + red)
    content(p, l, anchor: "south-west")
  }
})
```.text, ```
ortho(x: -60deg, y: 0deg, z: -30deg, {
  surface((x, y) => -x * y)
  for z in (-1, 1) { on-xy(z: z, rect((-1, -1), (1, 1), stroke: red)) }
  for (x, y) in ((-1, -1), (1, -1), (1, 1), (-1, 1)) {
    line((x, y, -1), (x, y, 1), stroke: red)
  }
})
```.text, prelude: surf)

=== Surfaces and 3D curves
#manual("api/draw-functions/projections/ortho", label: "ortho")
#variants("ortho(x: -60deg, y: 0deg, z: -30deg, surface(VALUE))",
  ("(x, y) => y", "(x, y) => -x * y", "(x, y) => calc.sin(3 * x) * calc.cos(3 * y)"),
  columns: 3, prelude: surf)
#variants(```
ortho(x: -60deg, y: 0deg, z: -30deg, {
  on-xy(grid((-1, -1), (1, 1), step: .5, stroke: silver))
  line(..VALUE, stroke: 1pt + red)
})
```.text, (
  "((0, 0, 1), (1, 0, 0), (1, 1, 0), (0, 1, 0))",
  "((0, 0, 0), (0, .5, 0), (0, 1, 1), (1, 1, 1), (1, .5, 0), (1, 0, 0))",
  "range(0, 721, step: 10).map(t => (calc.cos(t * 1deg), calc.sin(t * 1deg), t / 720))",
), columns: 3, prelude: surf)

=== Surface style
#manual("api/draw-functions/shapes/line", label: "line")
#unported[`shader=interp` (smooth color across a face)][Each face has one fill; raise `n` for a smoother look.]
#variants("ortho(x: -60deg, y: 0deg, z: -30deg, surface((x, y) => -x * y, VALUE))",
  ("stroke: .3pt", "stroke: none", "mesh: true", "n: 4", "n: 16", "n: 4, mesh: true"),
  columns: 3, prelude: surf)
#examples(```
ortho(x: -60deg, y: 0deg, z: -30deg, {
  let c = gradient.linear(..color.map.viridis)
  for x in range(-4, 5).map(i => i / 4) {
    for y in range(-4, 5).map(i => i / 4) {
      content((x, y, -x * y), std.circle(radius: 2pt, fill: c.sample((1 - x * y) * 50%)))
    }
  }
})
```.text, prelude: surf)

=== Color maps
#manual("api/draw-functions/styling/fill", label: "fill")
#variants("ortho(x: -60deg, y: 0deg, z: -30deg, surface((x, y) => y, map: VALUE))", (
  "color.map.viridis", "color.map.plasma", "color.map.inferno", "color.map.turbo",
  "color.map.cividis", "color.map.mako", "color.map.spectral",
  "(blue, silver.lighten(60%), red)",
), prelude: surf)
#examples(```
ortho(x: -60deg, y: 0deg, z: -30deg, surface((x, y) => y))
rect((1.8, -1), (2, 1), fill: gradient.linear(..color.map.viridis, dir: btt))
for z in (-1, 0, 1) { content((2, z), text(7pt)[#z], anchor: "west", padding: 3pt) }
```.text, prelude: surf)

=== Viewpoint
#manual("api/draw-functions/projections/ortho", label: "ortho")
#unported[Perspective view][`perspective` exists in 0.5.2, but a bug discards its projection, so it draws the same picture as `ortho`. Until it is fixed, project the points yourself: scale $x$ and $y$ by $d \/ (d - z)$ for a camera at distance $d$.]
#variants("ortho(x: VALUE, y: 0deg, z: -30deg, surface((x, y) => -x * y))",
  ("-20deg", "-45deg", "-60deg", "-80deg"), prelude: surf)
#variants("ortho(x: -60deg, y: 0deg, z: VALUE, surface((x, y) => -x * y))",
  ("-10deg", "-30deg", "-60deg", "-120deg"), prelude: surf)

=== Drawing order
#manual("api/draw-functions/projections/ortho", label: "ortho")
#variants(```
ortho(x: -60deg, y: 0deg, z: -30deg, sorted: VALUE, {
  on-xy(z: 1, rect((-1, -1), (1, 1), fill: red.lighten(40%)))
  on-xy(z: 0, rect((-1, -1), (1, 1), fill: eastern.lighten(40%)))
})
```.text, ("true", "false"), columns: 2)
`sorted: false` keeps the order of the code, e.g. to keep labels in front of faces.

== Data plots with lilaq <lilaq>
Use lilaq (`@preview/lilaq:0.6.0`) for plots with axes, ticks, legends and log scales;
its diagrams are plain content and sit next to a CeTZ canvas. cetz-plot 0.1.3 pins CeTZ 0.4.2,
so its plots cannot mix with 0.5.2 drawings.
#lilaq(```
// #import "@preview/lilaq:0.6.0" as lq
lq.diagram(
  width: 5cm, height: 3.5cm,
  title: [Title], xlabel: $x$, ylabel: $y$,
  lq.plot(range(-5, 6), x => x * x - x + 4, mark: "o", color: blue, label: $x^2 - x + 4$),
  lq.plot(range(-5, 6), x => x * x - x, mark: "s", color: red, label: $x^2 - x$),
)
```.text, ```
lq.diagram(
  width: 5cm, height: 3.5cm, yscale: "log",
  lq.plot((1, 2, 3, 4, 5), (2, 9, 30, 110, 400), yerr: (1, 3, 8, 20, 90), mark: "o", color: red),
)
```.text, ```
lq.diagram(
  width: 5cm, height: 3.5cm,
  lq.bar((1, 2, 3, 4, 5), (3, 5, 2, 4, 6), fill: eastern.lighten(50%)),
  lq.plot((1, 2, 3, 4, 5), (2, 4, 3, 5, 4), color: red),
)
```.text, ```
lq.diagram(
  width: 4cm, height: 4cm,
  lq.colormesh(lq.linspace(-1, 1), lq.linspace(-1, 1), (x, y) => -x * y),
)
```.text)
