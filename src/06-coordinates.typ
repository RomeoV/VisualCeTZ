#import "lib.typ": *

= Coordinates <coordinates>

== Small pictures
A TikZ `pic` is a Typst function that returns draw elements. Wrap them in `group` so transforms and styles stay local.

#let flag-def = ```
let flag(pos, name: none) = group(name: name, {
  set-origin(pos)
  rect((-.3, 0), (-.1, .4), fill: eastern)
  rect((-.1, 0), (.1, .4), fill: white)
  rect((.1, 0), (.3, .4), fill: red)
})
```.text + "\n"

=== Define and place
#manual("api/draw-functions/grouping/group", label: "group")
#examples(flag-def + "flag((0, 0))")
#variants("grid((0, 0), (2, 2), help-lines: true)\nflag(VALUE)",
  ("(1, 1)", "(45deg, 1.4)", "((0, 0), 25%, (2, 2))"), columns: 3, prelude: flag-def)

=== Pass style through
#manual("basics/styling", label: "styling")
#let seal-def = ```
let seal(pos, ..style) = group({
  set-origin(pos)
  circle((0, 0), radius: .4, ..style)
  line((-.3, -.3), (.3, .3), stroke: gray)
})
```.text + "\n"
#examples(seal-def + "seal((0, 0), stroke: red)")
#variants("seal((0, 0), VALUE)", (
  "fill: aqua",
  "stroke: 2pt + red",
  "fill: gradient.radial(white, eastern, focal-center: (30%, 30%))",
  "stroke: none, fill: red.lighten(50%)",
), columns: 4, prelude: seal-def)

=== Transform a picture
#manual("api/draw-functions/transformations/scale", label: "scale, rotate")
#variants("grid((0, 0), (2, 2), help-lines: true)\ngroup({\n  set-origin((1, 1))\n  VALUE\n  flag((0, 0))\n})",
  ("scale(2)", "rotate(45deg)", "scale(x: 3)", "scale(2)\nrotate(-30deg)"), prelude: flag-def)

Transforms move and resize shapes but not text; `auto-scale` scales `content` too, like TikZ `transform shape`.
#manual("api/draw-functions/shapes/content", label: "content")
#examples("scale(2)\ncontent((0, 0), [Aa])\ncontent((1, 0), [Aa], auto-scale: true)")

=== Repeat a picture
#examples("for x in range(10) {\n  flag((x * .8, 0))\n}", prelude: flag-def)

=== Behind or in front: layers
#manual("api/draw-functions/grouping/on-layer", label: "on-layer")
#variants("rect((0, 0), (1.5, 1), fill: lime, stroke: none)\nVALUE",
  ("flag((1.5, .3))", "on-layer(-1, flag((1.5, .3)))"), columns: 2, prelude: flag-def)

=== Place on a path
#manual("basics/anchors#path", label: "path anchors")
#examples(```
bezier((0, 0), (6, 0), (3, 1), name: "p")
flag("p.20%")
flag("p.mid")
circle("p.80%", radius: .3)
```.text, prelude: flag-def)
#unported[`sloped` for pictures][Rotate by the path direction yourself; for `content`, pass a coordinate to `angle`.]
#examples(```
bezier((0, 0), (6, 0), (3, 1), name: "p")
get-ctx(ctx => {
  let (_, a, b) = cetz.coordinate.resolve(
    ctx, "p.80%", "p.81%")
  group({
    set-origin(a)
    rotate(cetz.vector.angle2(a, b))
    flag((0, 0))
  })
})
content("p.20%", angle: "p.21%", anchor: "south", [sloped])
```.text, prelude: flag-def)

#let abc = "let (A, B, C) = ((2, 0), (0, 0), (1, 1))\nline(A, B, C)\n"

== Angles
#manual("api/libraries/angle/angle", label: "angle")
`cetz.angle.angle(origin, a, b)` marks the angle from `a` to `b` around `origin`. Below, `A = (2, 0)`, `B = (0, 0)`, `C = (1, 1)`, drawn as `line(A, B, C)`.

=== Side order and direction
#variants("cetz.angle.angle(VALUE, radius: .7, mark: (end: \"stealth\"))",
  ("B, A, C", "B, C, A", "B, A, C, direction: \"cw\"", "B, C, A, direction: \"near\""), prelude: abc)
Default `direction: "ccw"`; `"near"` and `"far"` pick the smaller or larger angle.

=== Style
#variants("cetz.angle.angle(B, A, C, radius: .8, VALUE)",
  ("fill: aqua", "stroke: 1pt + red", "stroke: (dash: \"dashed\")", "fill: red, stroke: none"),
  prelude: abc)

=== Radius
#variants("cetz.angle.angle(B, A, C, radius: VALUE)", ("0.5", "1", "50%", "100%"), prelude: abc)
Default `0.5`. A ratio is relative to the shorter side.

=== Label
#variants("cetz.angle.angle(B, A, C, radius: 1, VALUE)", (
  "label: $alpha$",
  "label: $alpha$, label-radius: 100%",
  "label: $alpha$, label-radius: 130%",
  "label: a => text(8pt)[#calc.round(a.deg())°]",
), prelude: abc)
Default `label-radius: 50%`, relative to `radius`.

=== Name and anchors
#examples(abc + ```
cetz.angle.angle(B, A, C, radius: 1, label: $alpha$, name: "x")
circle("x.label", radius: 6pt, stroke: red)
circle("x.start", radius: 2pt, fill: eastern)
circle("x.end", radius: 2pt, fill: eastern)
```.text)
Anchors: `origin`, `a`, `b`, `start`, `end`, `label`, `center`.

=== Right angle
#manual("api/libraries/angle/right-angle", label: "right-angle")
#variants("line((1.5, 0), (0, 0), (0, 1.5))\ncetz.angle.right-angle((0, 0), (1.5, 0), (0, 1.5), VALUE)",
  ("radius: .5", "label: none", "fill: aqua", "radius: 1, label: $R$"))
Defaults: `radius: .5`, `label: "•"`.

== Grid
#manual("api/draw-functions/shapes/grid", label: "grid")
#examples("grid((0, 0), (2, 2))")

#variants("grid((0, 0), (3, 3), help-lines: true)\ngrid((0, 0), (3, 3), stroke: red, step: VALUE)",
  ("0.75", "(x: 0.75)", "(y: 0.75)", "(0.5, 0.75)"), length: .8cm)

#variants("grid((0, 0), (3, 3), help-lines: true)\ngrid((0, 0), (3, 3), stroke: red, VALUE)",
  ("help-lines: true", "shift: 0.5", "shift: (0.5, 0)", "step: 1.5, shift: 0.5"), length: .8cm)

#examples("grid((0, 0), (3, 3), stroke: (paint: gray, dash: \"dotted\"))\nrotate(45deg)\ngrid((0, 0), (3, 3), stroke: red)", length: .8cm)

== Coordinate systems
#manual("basics/coordinate-systems", label: "coordinate systems")
Every argument that takes a position accepts any of the forms below. Numbers are canvas units (`cetz.canvas(length: 1cm)` by default); lengths are absolute.

#let bg = "grid((0, 0), (3, 2), help-lines: true)\n"

=== Canvas (xyz)
#manual("basics/coordinate-systems#xyz", label: "xyz")
#variants("circle(VALUE, radius: 2pt, fill: red)",
  ("(x: 2, y: 1.5)", "(2, 1.5)", "(2cm, 15mm)"), columns: 3, prelude: bg)

=== Polar
#manual("basics/coordinate-systems#polar", label: "polar")
#variants("line((0, 0), VALUE, stroke: (paint: eastern, dash: \"dotted\"))\ncircle(VALUE, radius: 2pt, fill: red)",
  ("(angle: 45deg, radius: 2)", "(45deg, 2)", "(45deg, (3, 2))"), columns: 3, prelude: bg)

=== Three axes
#manual("basics/coordinate-systems#xyz", label: "xyz")
A `z` component needs a projection such as `ortho` to show.
#examples(```
ortho({
  set-style(mark: (end: "stealth"))
  line((0, 0, 0), (x: 1), stroke: eastern)
  line((0, 0, 0), (y: 1), stroke: red)
  line((0, 0, 0), (z: 1), stroke: purple)
})
```.text, ```
ortho({
  set-style(mark: (end: "stealth"))
  line((0, 0, 0), (1, 0, 0), stroke: eastern)
  line((0, 0, 0), (0, 1, 0), stroke: red)
  line((0, 0, 0), (0, 0, 1), stroke: purple)
})
```.text)

=== Other unit vectors
#manual("api/draw-functions/transformations/scale", label: "scale, rotate")
TikZ `x=`, `y=` options: transform the axes, or pass `x:`, `y:`, `z:` vectors to `cetz.canvas` for the whole picture.
#variants("VALUE\ngrid((0, 0), (3, 2), help-lines: true)\nline((0, 0), (45deg, 2), stroke: (paint: eastern, dash: \"dotted\"))\ncircle((45deg, 2), radius: 2pt, fill: red)",
  ("scale(x: 1.5)", "scale(y: 50%)", "rotate(90deg)"), columns: 3)

=== Barycentric
#manual("basics/coordinate-systems#barycentric", label: "barycentric")
`A`…`D` are anchors at the corners of the square.
#let bary = ```
grid((0, 0), (3, 3), help-lines: true)
for (n, p) in (A: (0, 0), B: (3, 0), C: (3, 3), D: (0, 3)) {
  anchor(n, p)
  content(p, text(8pt, fill: blue, n), frame: "circle", fill: aqua.lighten(70%), stroke: none, padding: 1pt)
}
```.text + "\n"
#variants("circle((bary: VALUE), radius: 3pt, fill: red)", (
  "(A: 1, B: 1)", "(A: 2, B: 1)", "(A: 1, B: 1, C: 1)",
  "(A: 1, B: 1, C: 1, D: 1)", "(A: .2, B: .4, C: .6)", "(A: .2, B: .4, C: .6, D: .8)",
), columns: 3, length: .7cm, prelude: bary)

=== Named positions
#manual("api/draw-functions/grouping/anchor", label: "anchor")
#examples("grid((0, 0), (3, 3), help-lines: true)\n" + ```
anchor("centre", (1.5, 1.5))
anchor("A", (.5, .5))
anchor("B", (2.5, 2.5))
circle("centre", radius: 3pt, fill: eastern)
rect("A", "B", stroke: red)
```.text, length: .7cm)

=== Anchors of an element
#manual("basics/anchors", label: "anchors")
#let node = ```
grid((0, 0), (2, 2), help-lines: true)
content((1, 1), text(16pt, blue)[node], frame: "rect", padding: .1, fill: lime.lighten(60%), stroke: blue, name: "A")
```.text + "\n"
#variants("circle(VALUE, radius: 3pt, fill: red)",
  ("\"A.south\"", "\"A.west\"", "\"A.north\"", "\"A.east\"",
   "\"A.north-east\"", "\"A.south-west\"", "\"A.center\"", "\"A\""), prelude: node)
#variants("circle((name: \"A\", anchor: VALUE), radius: 3pt, fill: red)",
  ("\"south\"", "0deg", "-30deg", "-150deg"), prelude: node)
`"A"` alone is the default anchor. An angle is a border anchor: the ray from the center at that angle.

=== Positions along a path
#manual("basics/anchors#path", label: "path anchors")
#variants("line((0, 0), (1, 1), (3, 1), name: \"l\")\ncircle(VALUE, radius: 3pt, fill: red)",
  ("\"l.start\"", "\"l.25%\"", "\"l.mid\"", "(name: \"l\", anchor: 2)", "\"l.end\""), columns: 5, length: .7cm)
A ratio is a fraction of the path length; a number is a distance along the path.

=== Perpendicular and projection
#manual("basics/coordinate-systems#perpendicular", label: "perpendicular")
#let ab = ```
grid((0, 0), (3, 3), help-lines: true)
set-style(content: (frame: "circle", stroke: none, padding: 2pt, fill: aqua.lighten(60%)))
content((.5, .5), [A], name: "A")
content((2.5, 2.5), [B], name: "B")
```.text + "\n"
#variants("content((\"A\", VALUE, \"B\"), [X], fill: red.lighten(70%))",
  ("\"|-\"", "\"-|\""), columns: 2, prelude: ab, length: .8cm)
`(p, "|-", q)` has the x of `p` and the y of `q`.

#manual("basics/coordinate-systems#projection", label: "projection")
#examples(```
line((0, 0), (3, 1), name: "l")
circle((1, 2), radius: 2pt, fill: red, name: "p")
line("p", ("p", "_|_", "l.start", "l.end"), stroke: red, name: "h")
cetz.angle.right-angle("h.end", "p", "l.end", radius: .2, label: none)
```.text, ```
line((0, 0), (3, 1), name: "l")
circle((1, 2), radius: 2pt, fill: red, name: "p")
circle((project: "p", onto: ("l.start", "l.end")),
  radius: 2pt, fill: eastern)
```.text)

=== Intersections
#manual("api/draw-functions/grouping/intersections", label: "intersections")
#let cr = ```
grid((0, 0), (4, 2), help-lines: true)
circle((2, 1), name: "c", stroke: eastern)
rect((.5, .5), (3.5, 1.5), name: "r", stroke: eastern)
```.text + "\n"
`c` is `circle((2, 1))`, `r` is `rect((.5, .5), (3.5, 1.5))`. Intersections become anchors `i.0`, `i.1`, …
#variants("intersections(\"i\", \"c\", \"r\")\ncircle(VALUE, radius: 2pt, fill: red)",
  ("\"i.0\"", "\"i.1\"", "\"i.2\"", "\"i.3\""), length: .7cm, prelude: cr)
#examples(```
intersections("i", "c", "r")
for-each-anchor("i", n => {
  circle((), radius: 2pt, fill: red)
  content((), [#n], anchor: "south-west", padding: 2pt)
})
```.text, ```
intersections("i", "c", "r")
line("i.0", "i.2", stroke: red)
line("i.1", "i.3", stroke: teal)
```.text, ```
let by-angle = cetz.sorting.points-by-angle.with(reference: (2, 1))
intersections("i", "c", "r", sort: by-angle)
for-each-anchor("i", n => {
  circle((), radius: 2pt, fill: red)
  content((), [#n], anchor: "south-west", padding: 2pt)
})
```.text, length: .8cm, prelude: cr)
#examples(```
intersections("i", {
  circle((0, 0), stroke: eastern)
  hide(line((-1.5, -.5), (1.5, .5)))
})
line("i.0", "i.1", stroke: red)
```.text, length: .8cm)
#unported[`by={a,b,…}` renaming][Destructure the names: `let (a, b) = ("i.0", "i.1")`.]

=== Computed positions
#manual("basics/coordinate-systems#xyz", label: "xyz")
Coordinates are Typst arrays, so any Typst expression works.
#examples(bg + ```
circle((2, 1.5), radius: 3pt, fill: eastern)
circle((2 + .5, 1.5 - 1), radius: 3pt, fill: red)
```.text, "grid((0, 0), (4, 4), help-lines: true)\n" + ```
circle((2, 2), radius: 2, stroke: (paint: eastern, dash: "dashed"))
circle((2 + 2 * calc.cos(30deg), 2 + 2 * calc.sin(30deg)),
  radius: 3pt, fill: red)
circle((rel: (120deg, 2), to: (2, 2)), radius: 3pt, fill: purple)
```.text, length: .8cm)

=== Vector arithmetic
#manual("basics/coordinate-systems#function", label: "function")
A function coordinate receives the resolved coordinates as vectors; `cetz.vector` has the arithmetic.
#examples(bg + ```
content((1, 1), text(blue)[A], name: "a")
circle((rel: (2/3, 0), to: "a"), radius: 2pt, fill: red)
circle((v => cetz.vector.add(v, (4/3, 0)), "a"),
  radius: 2pt, fill: red)
```.text, bg + ```
content((.5, .5), [A], name: "A")
content((2, .5), [B], name: "B")
content((2.5, 1.5), [C], name: "C")
let f = (a, b, c) => cetz.vector.add(a, cetz.vector.sub(c, b))
circle((f, "A", "B", "C"), radius: 3pt, fill: red)
```.text)

=== Tangents
#manual("basics/coordinate-systems#tangent", label: "tangent")
#variants(```
circle((1, 1), radius: .75, name: "c", stroke: eastern)
content((3, 1.5), [A], name: "A")
line("A", (element: "c", point: "A", solution: VALUE), "c",
  stroke: (paint: red, dash: "dashed"))
circle((element: "c", point: "A", solution: VALUE), radius: 3pt, fill: red)
```.text, ("1", "2"), columns: 2, prelude: bg)
Works for circles and ellipses only.

=== Interpolation by ratio
#manual("basics/coordinate-systems#interpolation", label: "interpolation")
#let track = "grid((0, 0), (4, 2), help-lines: true)\nline((0, 1), (4, 1), stroke: 2pt + eastern)\n"
#variants("circle(((0, 1), VALUE, (4, 1)), radius: 4pt, fill: red)",
  ("25%", "75%", "0%", "100%"), length: .7cm, prelude: track)
#examples("grid((0, 0), (4, 3), help-lines: true)\n" + ```
line((0, 2), (4, 2), stroke: 2pt + eastern)
line((0, 0), ((0, 2), 75%, (4, 2)), stroke: red)
circle((((0, 2), 75%, (4, 2)), 66%, (0, 0)), radius: 3pt, fill: red)
```.text, length: .8cm)

=== Interpolation by distance
#manual("basics/coordinate-systems#interpolation", label: "interpolation")
#variants("circle(((0, 1), VALUE, (4, 1)), radius: 4pt, fill: red)",
  ("1.5", "3", "15mm", "-0.5"), length: .7cm, prelude: track)
An angle rotates the target around the start first:
#examples("grid((0, 0), (4, 3), help-lines: true)\n" + ```
line((0, 0), (4, 1), stroke: 2pt + eastern)
line((2, .5), ((2, .5), 2, 90deg, (4, 1)), stroke: 2pt + red)
```.text, length: .8cm)

=== Relative
#manual("basics/coordinate-systems#relative", label: "relative")
`(rel: v)` is `++v`: it moves the current position. With `update: false` it is `+v`.
#let rel-bg = "grid((0, 0), (5, 2), help-lines: true)\nset-style(line: (stroke: 1.5pt + eastern))\n"
#examples(
  "line((0, 1), (1, 1), (2, 2), (2, 0))",
  "line((0, 1), (1, 1),\n  (rel: (2, 1), update: false),\n  (rel: (2, -1), update: false))",
  "line((0, 1), (1, 1), (rel: (2, 1)), (rel: (2, -1)))",
  prelude: rel-bg, length: .7cm)
#examples(
  "rect((0, 0), (1, 1))\nrect((), (2, 2))\nrect((), (3, 3))",
  "rect((0, 0), (1, 1))\nrect((), (rel: (2, 2), update: false))\nrect((), (rel: (3, 3), update: false))",
  "rect((0, 0), (1, 1))\nrect((), (rel: (2, 2)))\nrect((), (rel: (3, 3)))",
  prelude: "grid((0, 0), (6, 6), help-lines: true)\nset-style(stroke: 1.5pt + eastern)\n", length: .4cm)
`()` is the current position. Polar and named coordinates work inside `rel`; `to:` sets the origin.
#examples(
  "line((0, 1), (rel: (0deg, 1)), (rel: (30deg, 2)), (rel: (-30deg, 2)))",
  "content((1, 1), [A], name: \"A\")\ncircle((rel: (1, -.5), to: \"A\"), radius: 3pt, fill: red)",
  prelude: rel-bg, length: .7cm)

=== Turning
#manual("basics/coordinate-systems#interpolation", label: "interpolation")
#unported[`[turn]` polar coordinates][Interpolate with an angle and a negative distance, which continues the last segment past its end.]
#variants(```
line((0, 0), (2, 1), name: "l", stroke: 1.5pt + eastern)
line("l.end", ("l.end", -1, VALUE, "l.start"), stroke: 1.5pt + red)
```.text, ("-45deg", "45deg", "0deg"), columns: 3, prelude: "grid((0, 0), (3, 2), help-lines: true)\n")
The same trick continues an arc along its tangent:
#examples("grid((0, 0), (3, 2), help-lines: true)\n" + ```
arc((3, 0), start: 0deg, stop: 120deg, radius: 1.5, name: "a",
  stroke: 1.5pt + eastern)
line("a.arc-end", ("a.arc-end", 1.5, -90deg, "a.origin"),
  stroke: 1.5pt + red)
```.text)
