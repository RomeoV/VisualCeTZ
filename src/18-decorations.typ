#import "lib.typ": *

= Decorations <decorations>

A path decoration takes an element as its target and draws a new path along it; the target itself is not drawn.
To also draw the original path, store the element in a variable and use it twice.
The pictures below draw the original path in grey.

#let ink = "set-style(stroke: teal)\n"

== Path morphing
#manual("api/libraries/decorations/path", label: "path decorations")

#variants("cetz.decorations.VALUE(circle((0, 0)), amplitude: .4, segments: 12)",
  ("zigzag", "wave", "coil", "square"), prelude: ink)

#variants(```
set-style(stroke: silver)
let p = VALUE
p
cetz.decorations.zigzag(p, amplitude: .25, segments: 16, stroke: teal)
```.text, (
  "line((0, 0), (2, 2))",
  "circle((0, 0))",
  "arc((0, 0), start: 0deg, stop: 180deg, radius: (1.5, 1))",
  "bezier((0, 0), (3, 0), (1, 2))",
), columns: 4)

Every decoration takes `segments` (default `10`) or `segment-length`, and `amplitude` (default `1`, measured peak to peak).
`segment-length` is rounded down to whole segments, which are then stretched to fill the path; the `align` key has no effect in 0.5.2.

=== Zigzag
#manual("api/libraries/decorations/path/zigzag", label: "zigzag")
#variants(```
let p = line((0, 0), (14, 0), stroke: silver)
p
cetz.decorations.zigzag(p, VALUE)
```.text, (
  "amplitude: .5",
  "amplitude: .25, segments: 30",
  "amplitude: .25, segment-length: 1",
), columns: 1, prelude: ink)

#variants(```
let p = circle((0, 0), stroke: silver)
p
cetz.decorations.zigzag(p, VALUE)
```.text, (
  "amplitude: .25, segments: 20",
  "amplitude: .8, segments: 20",
  "amplitude: .4, segment-length: .2",
  "amplitude: .4, segments: 5",
), prelude: ink)

=== Sawtooth
#manual("api/libraries/decorations/path/zigzag", label: "zigzag: factor")
#variants(```
let p = line((0, 0), (14, 0), stroke: silver)
p
cetz.decorations.zigzag(p, amplitude: .5, segments: 14, factor: VALUE)
```.text, ("0%", "25%", "50%", "100%"), columns: 1, prelude: ink)

#variants(```
let p = circle((0, 0), stroke: silver)
p
cetz.decorations.zigzag(p, amplitude: .5, segments: 16, factor: VALUE)
```.text, ("0%", "100%"), columns: 2, prelude: ink)

=== Wave
#manual("api/libraries/decorations/path/wave", label: "wave")
#variants(```
let p = line((0, 0), (14, 0), stroke: silver)
p
cetz.decorations.wave(p, VALUE)
```.text, (
  "amplitude: .5",
  "amplitude: .25, segments: 30",
), columns: 1, prelude: ink)

The `tension` key of `wave` has no effect in 0.5.2; set it on the `catmull` root instead.
#variants(```
set-style(catmull: (tension: VALUE))
let p = line((0, 0), (14, 0), stroke: silver)
p
cetz.decorations.wave(p, amplitude: .6, segments: 7)
```.text, (".4", ".5", "1"), columns: 1, prelude: ink)

#variants(```
let p = circle((0, 0), stroke: silver)
p
cetz.decorations.wave(p, VALUE)
```.text, (
  "amplitude: .25, segments: 20",
  "amplitude: .8, segments: 20",
  "amplitude: .3, segments: 6",
), columns: 3, prelude: ink)

=== Coil
#manual("api/libraries/decorations/path/coil", label: "coil")
#variants(```
let p = line((0, 0), (14, 0), stroke: silver)
p
cetz.decorations.coil(p, VALUE)
```.text, (
  "amplitude: .5",
  "amplitude: .5, segments: 25",
  "amplitude: .5, segments: 25, factor: 100%",
  "amplitude: .5, segments: 25, factor: 250%",
), columns: 1, prelude: ink)

#variants(```
let p = circle((0, 0), stroke: silver)
p
cetz.decorations.coil(p, VALUE)
```.text, (
  "amplitude: .5, segments: 16",
  "amplitude: .5, segments: 16, factor: 100%",
  "amplitude: .5, segments: 16, factor: 300%",
), columns: 3, prelude: ink)

=== Square wave
#manual("api/libraries/decorations/path", label: "path decorations: square")
#variants(```
let p = line((0, 0), (14, 0), stroke: silver)
p
cetz.decorations.square(p, amplitude: .5, segments: 14, factor: VALUE)
```.text, ("25%", "50%", "75%"), columns: 1, prelude: ink)

=== Amplitude per segment
#manual("api/libraries/decorations/path", label: "path decorations")
An array cycles per half segment; a function maps the position (`0%` to `100%`) to an amplitude.
#variants(```
let p = line((0, 0), (14, 0), stroke: silver)
p
cetz.decorations.zigzag(p, segments: 28, amplitude: VALUE)
```.text, (
  "(.6, .2)",
  "(.3, -.1, .5, .2, -.3, .1, .4)",
  "t => t / 100%",
  "t => calc.sin(t / 100% * 180deg)",
), columns: 1, prelude: ink)

=== Morphings without a CeTZ decoration
#manual("api/draw-functions/shapes/bezier", label: "bezier")
#unported[`straight zigzag`, `random steps`, `bent`, `bumps`, `lineto`, `curveto`][Use an amplitude array with zeros for a straight zigzag and for pseudo-random steps, `bezier-through` for a bent path, a loop of `arc`s for bumps, and `amplitude: 0` to replace a path by its chords. `curveto` leaves the path unchanged.]
#examples(
  "cetz.decorations.zigzag(line((0, 0), (4, 0)), segments: 20,\n  amplitude: (0,) * 6 + (.4,) * 4, stroke: teal)",
  "cetz.decorations.zigzag(line((0, 0), (4, 0)), segments: 12,\n  amplitude: (.3, -.1, .4, .2, -.3, .1, .2), stroke: teal)",
  "bezier-through((0, 0), (2, .5), (4, 0), stroke: teal)",
  "for i in range(8) {\n  arc((i / 2, 0), start: 180deg, stop: 0deg, radius: .25,\n    stroke: teal)\n}",
  "circle((0, 0), stroke: silver)\ncetz.decorations.zigzag(circle((0, 0)), amplitude: 0,\n  segments: 5, stroke: teal)",
)

== Braces
#manual("api/libraries/decorations/braces", label: "braces")

=== Brace
#manual("api/libraries/decorations/braces/brace", label: "brace")
#examples(```
line((0, 0), (3, 1), stroke: silver)
cetz.decorations.brace((0, 0), (3, 1), name: "b", fill: red)
content("b.content", [$x$])
```.text, ```
cetz.decorations.brace((0, 0), (3, 0), name: "b", fill: red,
  amplitude: .5, content-offset: .5)
for (a, s) in (start: "north", end: "north",
    spike: "west", content: "west") {
  circle("b." + a, radius: .04, fill: blue, stroke: none)
  content("b." + a, text(7pt, raw(a)), anchor: s, padding: .1)
}
```.text)

#variants("cetz.decorations.brace((0, 0), (3, 0), VALUE)", (
  "amplitude: .25",
  "amplitude: .6",
  "flip: true",
  "pointiness: 0%",
  "thickness: .08",
  "outer-inset: 0",
  "inner-outset: .6",
  "taper: false, stroke: red, fill: none",
), prelude: "line((0, 0), (3, 0), stroke: silver)\nset-style(brace: (fill: red))\n")

#unported[`raise` and braces along a curved path][A brace spans the straight line between two points; move both points to raise it.]

=== Flat brace
#manual("api/libraries/decorations/braces/flat-brace", label: "flat-brace")
#variants("cetz.decorations.flat-brace((0, 0), (3, 0), stroke: red, VALUE)", (
  "amplitude: .3",
  "amplitude: .6",
  "flip: true",
  "aspect: 25%",
  "aspect: 75%",
  "curves: .2",
  "outer-curves: 0",
  "curves: 0",
), prelude: "line((0, 0), (3, 0), stroke: silver)\n")

== Path replacing
#manual("basics/coordinate-systems#interpolation", label: "interpolation")
#unported[`border`, `ticks`, `waves`, `expanding waves`, `show path construction`][Loop over path anchors and draw each piece; an interpolation coordinate with an angle gives the normal. There is no public API to visit the segments of a path.]
#examples(```
circle((0, 0), name: "c", stroke: silver)
for i in range(20) {
  let (p, q) = ((name: "c", anchor: i * 5%), (name: "c", anchor: i * 5% + 1%))
  line((p, -.15, 90deg, q), (p, .15, 90deg, q), stroke: red)
}
```.text, ```
circle((0, 0), name: "c", stroke: silver)
for i in range(20) {
  let (p, q) = ((name: "c", anchor: i * 5%), (name: "c", anchor: i * 5% + 1%))
  line(p, (p, .4, 45deg, q), stroke: red)
}
```.text, ```
line((0, 0), (20deg, 2), stroke: (paint: red, dash: "dashed"))
line((0, 0), (-20deg, 2), stroke: (paint: red, dash: "dashed"))
for r in (.4, .8, 1.2, 1.6, 2) {
  arc((0, 0), start: -20deg, stop: 20deg, radius: r, anchor: "origin",
    stroke: teal)
}
```.text)

== Markings
#manual("basics/anchors#path", label: "path anchors")
A path anchor is a ratio of the path length or an absolute distance from its start.
A circle starts at its north and runs counter-clockwise.

=== Mark at one position
#manual("basics/anchors#path", label: "path anchors")
#variants(```
circle((0, 0), name: "c", stroke: silver)
circle((name: "c", anchor: VALUE), radius: .08, fill: red)
content((name: "c", anchor: VALUE), text(red)[text],
  anchor: "south", padding: .15)
```.text, ("0%", "25%", "60%", "1", "2.5"), columns: 5)

=== Marks with a step
#manual("basics/anchors#path", label: "path anchors")
#variants(```
circle((0, 0), name: "c", stroke: silver)
for t in VALUE {
  circle((name: "c", anchor: t), radius: .07, fill: red)
}
```.text, (
  "range(10).map(i => i * 10%)",
  "range(10).map(i => i * 5%)",
  "range(7)",
  "range(0, 6, step: 2)",
), columns: 2)

=== Marks rotated with the path
#manual("api/draw-functions/shapes/content", label: "content: angle")
#examples(```
circle((0, 0), name: "c", stroke: silver)
for t in (35%, 50%, 65%) {
  content((name: "c", anchor: t), angle: (name: "c", anchor: t + 1%),
    box(fill: aqua, inset: 3pt)[text])
}
```.text, ```
line((0, 0), (3, 2), name: "l", stroke: silver)
content((name: "l", anchor: 40%), angle: "l.end", [text], frame: "rect",
  fill: white, stroke: red, padding: .1)
```.text)

=== Numbered marks
#manual("api/draw-functions/shapes/content", label: "content")
#examples(```
arc((0, 0), start: 180deg, stop: 30deg, radius: 2, name: "a",
  stroke: teal)
for i in range(1, 6) {
  content((name: "a", anchor: (i - 1) * 20%), [#i], name: "m" + str(i),
    frame: "circle", fill: white, stroke: red, padding: .05)
}
line("m3", "m5", stroke: 2pt + red)
```.text, ```
arc((0, 0), start: 180deg, stop: 30deg, radius: 2, name: "a",
  stroke: teal)
for d in range(5) {
  content((name: "a", anchor: d), text(7pt)[#d], frame: "rect",
    fill: white, stroke: red, padding: .05)
}
```.text)

=== Arrow tips on the path
#manual("basics/marks", label: "marks: pos")
`pos` moves a mark along its path; `shorten-to: none` keeps the path at full length.
#variants(```
arc((0, 0), start: 0deg, stop: 180deg, radius: 1, stroke: teal,
  mark: (end: VALUE, pos: 40%, shorten-to: none, scale: 2, fill: red))
```.text, ("\">\"", "\">>\"", "\"|\"", "\"<>\"", "\"o\"", "\"]\"", "\"<\"", "\"barbed\""))

#examples(```
circle((0, 0), name: "c", stroke: teal)
for t in (0%, 25%, 50%, 75%) {
  mark((name: "c", anchor: t), (name: "c", anchor: t + 1%),
    symbol: ">>", scale: 2, fill: red)
}
```.text)

== Footprints
#manual("api/draw-functions/shapes/content", label: "content")
#unported[The `footprints` decoration][Place a symbol or content at path anchors in a loop, as in the markings above.]

== Shapes along a path
#manual("api/draw-functions/shapes/polygon", label: "polygon")
#unported[The `shapes` decorations (`crosses`, `triangles`, `shape backgrounds`)][Place shapes at path anchors in a loop.]
#variants(```
arc((0, 0), start: 180deg, stop: 0deg, radius: 1.5, name: "a",
  stroke: silver)
set-style(stroke: red)
for i in range(7) {
  let p = (name: "a", anchor: 8% + i * 14%)
  VALUE
}
```.text, (
  "circle(p, radius: .15)",
  "rect((rel: (-.12, -.12), to: p), (rel: (.24, .24)))",
  "polygon(p, 5, radius: .18)",
  "n-star(p, 5, radius: .2)",
  "mark(p, (name: \"a\", anchor: 9% + i * 14%), symbol: \">\", anchor: \"center\", scale: 2)",
  "mark(p, 0deg, symbol: \">\", anchor: \"center\", scale: 2)",
  "circle(p, radius: .05 + i * .03, fill: aqua)",
  "circle(p, radius: .1, fill: if calc.even(i) { red } else { white })",
), columns: 4)

== Text along a path
#manual("api/draw-functions/shapes/content", label: "content: angle")
#unported[`text along path`][Place one character per path anchor and rotate it towards the next anchor. The step is fixed, so proportional fonts are spaced unevenly.]
#examples(```
arc((0, 0), start: 180deg, stop: 0deg, radius: 1.5, name: "a",
  stroke: silver)
for (i, ch) in "Visual CeTZ".clusters().enumerate() {
  let d = .5 + i * .35
  content((name: "a", anchor: d), angle: (name: "a", anchor: d + .1),
    text(red, ch), anchor: "south")
}
```.text)

== Fractals
#manual("basics/coordinate-systems#interpolation", label: "interpolation")
#unported[`Koch curve type 1`, `Koch curve type 2`, `Koch snowflake`, `Cantor set`][Write a recursive function that returns points. Interpolation coordinates keep it short.]
#variants(```
let koch(a, b, n) = if n == 0 { (a,) } else {
  let (c, e) = ((a, 100% / 3, b), (a, 200% / 3, b))
  let d = (c, 100%, 60deg, e)
  koch(a, c, n - 1) + koch(c, d, n - 1) + koch(d, e, n - 1) + koch(e, b, n - 1)
}
let (a, b, c) = ((0, 0), (1.5, 2.6), (3, 0))
line(..koch(a, b, VALUE), ..koch(b, c, VALUE), ..koch(c, a, VALUE), close: true,
  fill: aqua.lighten(50%), stroke: blue)
```.text, ("0", "1", "2", "3"))

== Applications

=== Decorated shapes
#manual("api/libraries/decorations/path", label: "path decorations")
#variants(```
cetz.decorations.VALUE(rect((0, 0), (3, 2)), amplitude: .2, segments: 14,
  fill: lime.lighten(50%), stroke: teal)
content((1.5, 1), [text])
```.text, ("zigzag", "wave", "square", "coil"))

#variants(```
cetz.decorations.VALUE(circle((0, 0), radius: (1.5, 1)), amplitude: .25,
  segments: 16, fill: yellow, stroke: orange)
content((0, 0), [text])
```.text, ("zigzag", "wave", "square", "coil"))

Decorate a node frame with `rect-around`; `on-layer` puts it behind the text.
#examples(```
content((0, 0), [text], name: "t", padding: .2)
on-layer(-1, cetz.decorations.wave(rect-around("t"), amplitude: .15,
  segments: 12, fill: aqua.lighten(50%), stroke: blue))
```.text)

=== Decorated links
#manual("api/libraries/decorations/path", label: "path decorations")
Here `A` and `B` are framed `content` elements.
#let nodes = "content((0, 0), [A], name: \"A\", frame: \"rect\", stroke: red, padding: .1)\ncontent((3, 2), [B], name: \"B\", frame: \"rect\", stroke: red, padding: .1)\nset-style(stroke: teal)\n"
#examples(
  "cetz.decorations.wave(line(\"A.north-east\", \"B.south-west\"),\n  amplitude: .2, segments: 8)",
  "cetz.decorations.coil(line(\"A.north\", (\"A\", \"|-\", \"B\"), \"B.west\"),\n  amplitude: .2, segments: 12)",
  "cetz.decorations.zigzag(bezier(\"A.east\", \"B.south\", (3, 0)),\n  amplitude: .2, segments: 12)",
  "cetz.decorations.square(arc-through(\"A.north\", (.8, 1.8), \"B.west\"),\n  amplitude: .15, segments: 10)",
  prelude: nodes)

=== Decorated plots
#manual("api/libraries/decorations/path", label: "path decorations")
#examples(```
line((0, -2), (0, 2), mark: (end: ">"))
line((0, 0), (6.5, 0), mark: (end: ">"))
let p = line((0, 0), (2, 1), (4, -2), (6, 1),
  stroke: (paint: red, dash: "dashed"))
p
cetz.decorations.zigzag(p, amplitude: .3, segment-length: .4,
  stroke: teal)
```.text, ```
line((0, -2), (0, 2), mark: (end: ">"))
line((0, 0), (6.5, 0), mark: (end: ">"))
let p = catmull(..range(7).map(x => (x, calc.sin(x))),
  stroke: (paint: red, dash: "dashed"))
p
cetz.decorations.wave(p, amplitude: .3, segment-length: .4,
  stroke: teal)
```.text, length: .6cm)

=== Partial decoration
#manual("api/libraries/decorations/path", label: "path decorations: start, stop, rest")
`start` and `stop` limit the decoration; `rest` draws (`"LINE"`) or drops (`none`) the remaining path.
#variants(```
cetz.decorations.zigzag(line((0, 0), (14, 0)), amplitude: .4, segment-length: .5,
  VALUE)
```.text, (
  "stop: 50%",
  "start: 50%",
  "start: 30%, stop: 70%",
  "start: 30%, stop: 70%, rest: none",
  "start: 3, stop: 11",
), columns: 1, prelude: ink)

Decorate only some sides of a closed path by merging plain and decorated parts.
#examples(```
merge-path(close: true, fill: aqua.lighten(60%), {
  line((0, 0), (3, 0))
  cetz.decorations.zigzag(line((), (3, 1.5)), amplitude: .2, segments: 5)
  line((), (0, 1.5))
})
```.text, ```
let z = cetz.decorations.zigzag.with(amplitude: .2, segments: 8)
merge-path(close: true, fill: aqua.lighten(60%), {
  z(line((0, 0), (3, 0)))
  line((), (3, 1.5))
  z(line((), (0, 1.5)))
})
```.text, prelude: ink)

Chain decorations on one path by splitting it with `start` and `stop`.
#examples(```
let p = line((0, 0), (8, 0))
cetz.decorations.zigzag(p, amplitude: .4, stop: 50%, rest: none)
cetz.decorations.coil(p, amplitude: .4, start: 50%, rest: none)
```.text, prelude: ink, length: .6cm)

=== Style for all decorations
#manual("api/draw-functions/styling/set-style", label: "set-style")
Each decoration reads its style from its root key: `zigzag`, `wave`, `coil`, `square`, `brace`, `flat-brace`.
#examples(```
set-style(zigzag: (amplitude: .5, segment-length: 1,
  stroke: teal))
line((0, 2), (6, 2), stroke: red)
cetz.decorations.zigzag(line((0, 1), (6, 1)))
cetz.decorations.zigzag(line((0, 0), (6, 0)), factor: 100%)
cetz.decorations.zigzag(line((0, -1), (6, -1)), stop: 50%)
```.text)

=== Path and its decoration
#manual("api/libraries/decorations/path/zigzag", label: "zigzag")
#examples(```
let p = arc((0, 0), start: 0deg, stop: 180deg,
  radius: (2.5, 1.5), stroke: 10pt + red)
p
cetz.decorations.zigzag(p, amplitude: .8, segments: 12,
  stroke: 2pt + teal)
```.text, length: .7cm)
