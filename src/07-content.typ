#import "lib.typ": *

= Content and anchors <content>

CeTZ has no nodes. `content` places Typst content at a coordinate, `frame` draws a box or circle around it, and `name` makes its anchors available to later elements.

// Quote each value as a Typst string literal.
#let q(..names) = names.pos().map(n => "\"" + n + "\"")
#let help(x0, y0, x1, y1) = "grid((" + str(x0) + ", " + str(y0) + "), (" + str(x1) + ", " + str(y1) + "), stroke: silver)\n"

== Creating content
#manual("api/draw-functions/shapes/content", label: "content")
#variants("content((1, 1), [Aa], VALUE)", (
  "frame: none", "frame: \"rect\"", "frame: \"circle\"",
  "frame: \"rect\", padding: .25",
  "frame: \"rect\", stroke: none, fill: aqua.lighten(50%)",
  "frame: \"circle\", stroke: red, fill: red.lighten(80%)",
), columns: 3, prelude: help(0, 0, 2, 2))

=== A named point
#manual("api/draw-functions/grouping/anchor", label: "anchor")
#examples(```
anchor("P", (1, 1))
circle("P", radius: .1, fill: red, stroke: none)
```.text, prelude: help(0, 0, 2, 2))

=== Several at once
#examples(
```
for x in range(1, 6) {
  content((x, 0), [#x])
}
```.text,
```
set-style(content: (frame: "rect", stroke: red, padding: .1))
for x in range(1, 6) {
  content((x, 0), [#x])
}
```.text,
```
let sq = (frame: "rect", stroke: red)
let ci = (frame: "circle", stroke: blue)
for (x, s) in (sq, ci, ci, sq, sq).enumerate() {
  content((x, 0), [#x], padding: .1, ..s)
}
```.text)

== Names and anchors
#manual("basics/anchors", label: "anchors")
#examples(
```
content((0, 0), [A], name: "A", frame: "rect", padding: .1)
circle("A", radius: .5, stroke: eastern)
```.text,
```
set-style(circle: (radius: 1.5pt, stroke: none))
content((0, 0), text(22pt, silver)[Wag],
  frame: "rect", padding: .35, name: "c")
for a in ("north", "north-east", "east", "south-east", "south",
    "south-west", "west", "north-west", "center") {
  circle("c." + a, fill: red)
  content("c." + a, text(6pt, a), anchor: "north", padding: .05)
}
```.text)
#variants(```
content((0, 0), text(22pt, gray)[Wag],
  frame: "rect", padding: .15, stroke: blue, name: "c")
circle("c." + VALUE, radius: 2pt, fill: red, stroke: none)
```.text, q("mid-west", "mid", "mid-east", "text", "base-west", "base", "base-east", "center"))
#unported[`alias`][`anchor("B", "A")` names a second point at A's default anchor.]

== Content body
#manual("api/draw-functions/shapes/content", label: "content")
#variants("content((0, 0), VALUE, frame: \"rect\", stroke: none,\n  fill: aqua.lighten(60%), padding: .1)", (
  "[XXX]", "text(red)[XXX]", "text(14pt, weight: \"bold\")[XXX]",
  "$x^2 + y^2$", "[XXX \\ YYY]", "box(width: 1.6cm)[a long text that wraps]",
), columns: 3)

=== Rotation
#variants("content((0, 0), [XXX], angle: VALUE, frame: \"rect\", padding: .1)",
  ("0deg", "30deg", "90deg", "-45deg"))

=== Text style for all content
#examples(```
set-style(content: (wrap: text.with(fill: red, weight: "bold")))
content((0, 0), [A])
content((1, 0), [B])
```.text)

=== Content inside a rectangle
#examples(```
rect((0, 0), (4, 1.6), stroke: silver)
content((0, 0), (4, 1.6), box(width: 100%, height: 100%, inset: 4pt,
  par(justify: true)[The text fills the box between the two coordinates.]))
```.text)

== Behind or in front
#manual("api/draw-functions/grouping/on-layer", label: "on-layer")
#variants(```
on-layer(VALUE, content((0, 0), text(16pt)[Text], frame: "rect",
  stroke: none, fill: red.lighten(60%)))
rect((0, -.1), (1.2, .8), fill: aqua, stroke: blue)
```.text, ("-1", "1"), columns: 2)
More on layers in #see(<structure>).

== Name prefixes
#manual("api/draw-functions/grouping/group", label: "group")
#unported[`name prefix`, `name suffix`][A named `group` prefixes the names of its children: `"top.A"`.]
#examples(```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
for (g, y) in (("top", 1), ("bottom", 0)) {
  group(name: g, {
    for (x, t) in ("A", "B", "C").enumerate() {
      content((x, y), t, name: t)
    }
  })
}
line("top.A.south", "bottom.C.north", stroke: red)
```.text)

== Links
#manual("api/draw-functions/shapes/line", label: "line")
#let links = ```
set-style(content: (frame: "rect", padding: .1,
  fill: white, stroke: blue))
on-layer(1, {
  content((0, 0), [A], name: "A")
  content((2, 1.5), [B], name: "B")
})
```.text + "\n"
#examples(links + "line(\"A\", \"B\")")
`line` stops at the frames of named elements. Curves do not, so the pictures below keep the setup above: the frames sit on layer 1 and hide the curve ends.
#variants("line(VALUE)", (
  "\"A\", \"B\"", "\"A\", (\"A\", \"|-\", \"B\"), \"B\"", "\"A\", (\"A\", \"-|\", \"B\"), \"B\"",
), columns: 3, prelude: links)

=== Bent links
#manual("api/draw-functions/shapes/bezier", label: "bezier")
#variants("bezier(\"A\", \"B\", (\"A\", 40%, VALUE, \"B\"), (\"B\", 40%, -VALUE, \"A\"))",
  ("-45deg", "0deg", "30deg", "45deg", "90deg", "120deg"), columns: 3, prelude: links)

=== Control points
#variants("let (a, b) = VALUE\nbezier(\"A\", \"B\", (rel: a, to: \"A\"), (rel: b, to: \"B\"))", (
  "((2, 0), (0, -2))", "((0, 1), (-1, 0))", "((1, 0), (2, 0))",
  "((0, 1), (2, 0))", "((120deg, 2), (200deg, 1))", "((90deg, 1), (-90deg, 1))",
), columns: 3, prelude: links)
#variants("bezier(\"A\", \"B\", VALUE)", ("\"C\", \"D\"", "\"D\""), columns: 2,
  prelude: links + "content((0, 1.2), [C], name: \"C\")\ncontent((2.2, 0), [D], name: \"D\")\n")

=== Link style
#variants("line(\"B\", \"A\", VALUE)", (
  "mark: (end: \"straight\")", "stroke: red", "stroke: (dash: \"dashed\")",
), columns: 3, prelude: links)

== Labels
#manual("basics/anchors", label: "anchors")
#block(sticky: true)[Place content at a point and choose which of its anchors lands there.]
#let dot = "circle((0, 0), radius: 2pt, fill: red, stroke: none)\n"
#variants(dot + "content((0, 0), [text], anchor: VALUE)",
  q("south", "north", "east", "west", "south-east", "south-west", "north-east", "north-west"),
  prelude: help(-1, -1, 1, 1))

=== Distance
#variants(dot + "content((0, 0), [text], anchor: VALUE, padding: .3)",
  q("south", "north", "east", "west", "south-east", "south-west", "north-east", "north-west"),
  prelude: help(-1, -1, 1, 1))

=== Label on a named element
#variants(```
rect((-.2, -.2), (.2, .2), stroke: blue, name: "n")
content((name: "n", anchor: VALUE), [label], anchor: VALUE + 180deg, padding: .05)
```.text, ("0deg", "90deg", "180deg", "270deg", "45deg"), columns: 5)

== Pins
#manual("basics/anchors#border", label: "border anchors")
#variants(```
circle((0, 0), radius: .25, stroke: blue, name: "c")
line((name: "c", anchor: VALUE), (rel: (VALUE, .6)), stroke: gray)
content((), [pin], anchor: VALUE + 180deg)
```.text, ("90deg", "60deg", "0deg", "210deg"))

=== Pin length
#variants(```
circle((0, 0), radius: .25, stroke: blue, name: "c")
line("c.north", (rel: (0, VALUE)), stroke: gray)
content((), [pin], anchor: "south")
```.text, ("0", ".3", ".6", "1.2"))

== Content along a path
#manual("basics/anchors#path", label: "path anchors")
#variants(```
bezier((0, 0), (4, 0), (1, 2), (2, -1), name: "p")
circle((name: "p", anchor: VALUE), radius: 2pt, fill: red, stroke: none)
content((), [text], anchor: "south", padding: .1)
```.text, ("0%", "12.5%", "25%", "50%", "75%", "100%", "\"start\"", "\"mid\"", "1.5"),
  columns: 3)
`"mid"` is 50% of the path length; a number is an absolute distance along the path.

=== Sloped
#variants(```
bezier((0, 0), (4, 0), (1, 2), (2, -1), name: "p")
content("p.50%", angle: "p.51%", [text], anchor: VALUE, padding: .1)
```.text, q("south", "center", "north"), columns: 3)

== Labels on links
#manual("api/draw-functions/shapes/content", label: "content")
#variants("line((0, 0), (3, 0), name: \"l\")\ncontent(VALUE, padding: .1)", (
  "\"l.mid\", [abc], anchor: \"south\"",
  "\"l.20%\", [abc], anchor: \"south\"",
  "\"l.mid\", [abc], anchor: \"north\"",
  "\"l.mid\", text(14pt)[abc], anchor: \"south\"",
  "\"l.mid\", text(red)[abc], anchor: \"south\"",
  "\"l.mid\", [abc], frame: \"rect\", fill: white",
  "\"l.mid\", [abc], frame: \"rect\", fill: white, stroke: none",
  "\"l.mid\", [abc], frame: \"rect\", stroke: none,\n  fill: yellow",
  "\"l.mid\", [abc], angle: 10deg, anchor: \"south\"",
), columns: 3)

=== Style for all labels
#examples(```
set-style(content: (frame: "rect", stroke: none, fill: yellow))
line((0, 0), (3, 0), name: "l")
content("l.mid", [abc])
```.text)

== Relative placement
#manual("basics/coordinate-systems#relative", label: "relative coordinates")
#variants(```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
content((0, 0), [a], name: "a")
content((rel: (0, VALUE), to: "a.north"), [b], anchor: "south")
```.text, (".5", "1", ".5 + calc.sin(60deg)"), columns: 3, prelude: help(-1, 0, 1, 3))

=== Diagonal
#variants(```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
content((0, 0), [node a], name: "a")
content((rel: VALUE, to: "a.north-east"), [XXX], anchor: "south-west")
```.text, ("(0, 2)", "(2, 1)", "(1, -1)"), columns: 3, prelude: help(-1, -1, 3, 3))

=== Border to border or centre to centre
#examples(
```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
content((0, 0), [node a], name: "a")
content((rel: (0, 1), to: "a.north"), [node b], anchor: "south", name: "b")
content((rel: (0, 1), to: "b.north"), [node c], anchor: "south")
```.text,
```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
content((0, 0), [node a], name: "a")
content((rel: (0, 1), to: "a"), [node b], name: "b")
content((rel: (0, 1), to: "b"), [node c])
```.text, prelude: help(-1, 0, 1, 3))

=== Baseline alignment
#examples(
```
set-style(content: (frame: "rect", padding: .05, stroke: blue))
content((0, 0), text(28pt)[X], name: "X")
content((rel: (.6, 0), to: "X.east"), text(12pt)[a],
  anchor: "west", name: "a")
content((rel: (.6, 0), to: "a.east"), text(28pt)[g], anchor: "west")
```.text,
```
set-style(content: (frame: "rect", padding: .05, stroke: blue))
content((0, 0), text(28pt)[X], name: "X")
content((rel: (.6, 0), to: "X.base-east"), text(12pt)[a],
  anchor: "base-west", name: "a")
content((rel: (.6, 0), to: "a.base-east"), text(28pt)[g],
  anchor: "base-west")
```.text)

== Fitting
#manual("api/draw-functions/shapes/rect-around", label: "rect-around")
#let pts = ```
for (n, p) in (a: (.5, 1), b: (2, .25), c: (1, 2),
    d: (1.25, .25), e: (1.75, 1.5)) {
  content(p, [#n], name: n, frame: "circle", padding: .03,
    stroke: blue)
}
```.text + "\n"
#examples(
```
for p in ((.5, 1), (2, .25), (1, 2), (1.25, .25), (1.75, 1.5)) {
  circle(p, radius: 2pt, fill: blue, stroke: none)
}
rect-around((.5, 1), (2, .25), (1, 2), (1.25, .25), (1.75, 1.5),
  stroke: 2pt + red)
```.text,
pts + "rect-around(\"a\", \"b\", \"c\", \"d\", \"e\", stroke: 2pt + red)",
prelude: help(0, 0, 2, 2))

#variants("rect-around(\"a\", \"b\", \"c\", \"d\", \"e\", VALUE)", (
  "stroke: red", "padding: .3, stroke: red", "padding: .3, radius: .3, stroke: red",
), columns: 3, prelude: help(0, 0, 2, 2) + pts)

=== Anchors of the fit
#variants("rect-around(\"a\", \"b\", \"c\", \"d\", \"e\", name: \"f\", stroke: red)\ncontent(\"f.VALUE\", [x], frame: \"rect\", stroke: none, fill: lime)",
  ("east", "north-east", "center"), columns: 3, prelude: help(0, 0, 2, 2) + pts)

=== Rotated or round
#examples(
```
rotate(45deg)
rect-around("a", "b", "c", "d", "e", stroke: red)
```.text,
```
rect-around("a", "b", "c", "d", "e", name: "f", stroke: none)
circle("f.center", "f.north-east", stroke: red)
```.text, prelude: help(0, 0, 2, 2) + pts)
Other frame shapes are in #see(<shapes>).

== Circle through points
#manual("api/draw-functions/shapes/circle", label: "circle")
#examples(
```
content((2, 1), [c])
circle((2, 1), (1, 2), stroke: blue)
circle((1, 2), radius: 2pt, fill: red, stroke: none)
```.text,
```
let (a, b, c) = ((1, 0), (3, 1), (1, 2))
circle-through(a, b, c, stroke: blue)
for p in (a, b, c) {
  circle(p, radius: 2pt, fill: red, stroke: none)
}
```.text, prelude: help(0, 0, 3, 2))

== Matrices
#manual("basics/coordinate-systems#anchor", label: "anchor coordinates")
#unported[`matrix`, `matrix of nodes`][Nested `for` loops place the cells and name them. For pure alignment, a Typst `table` or `$mat(..)$` inside one `content` is simpler.]
#examples(```
let m = ((8, 1, 6), (3, 5, 7), (4, 9, 2))
for (i, row) in m.enumerate() {
  for (j, v) in row.enumerate() {
    content((j, -i), [#v], name: "m-" + str(i) + "-" + str(j),
      frame: "rect", padding: .1, stroke: blue)
  }
}
line("m-0-0", "m-1-2", stroke: red, mark: (end: "straight"))
```.text)

=== Cell styles
#variants(```
for (i, row) in ((8, 1, 6), (3, 5, 7), (4, 9, 2)).enumerate() {
  for (j, v) in row.enumerate() {
    let hit = VALUE
    content((j * .6, -i * .6), text(if hit { red } else { blue })[#v])
  }
}
```.text, ("i == 1", "j == 1", "i == 1 and j == 1", "calc.odd(i + j)"))

=== Alignment in a column
#variants(```
for (i, row) in (("12345", "67890"), ("123", "67"), ("1", "6")).enumerate() {
  for (j, v) in row.enumerate() {
    content((j * 1.6, -i * .5), v, anchor: VALUE)
  }
}
```.text, q("west", "east", "center"), columns: 3)

=== Spacing
#variants(```
for (i, row) in ((1, 2, 3), (4, 5, 6)).enumerate() {
  for (j, v) in row.enumerate() {
    let (dx, dy) = VALUE
    content((j * dx, -i * dy), [#v], frame: "rect", padding: .1, stroke: blue)
  }
}
```.text, ("(.6, .6)", "(1.2, .6)", "(.6, 1.2)"), columns: 3)

=== Anchoring
#manual("api/draw-functions/grouping/group", label: "group")
#block(sticky: true)[The group's `anchor` moves onto its `"default"` anchor.]
#variants(```
circle((1, 1), radius: 2pt, fill: red, stroke: none)
group(anchor: VALUE, {
  anchor("default", (1, 1))
  for (i, v) in ("123", "12", "1").enumerate() {
    content((1, 1 - i * .5), v, name: "c" + str(i),
      frame: "rect", padding: .05, stroke: blue)
  }
})
```.text, q("west", "east", "south", "c1.east"), prelude: help(0, -1, 3, 2), length: .9cm)

=== Empty cells
#examples(
```
let m = (($a_1$, none, $a_3$), ($a_4$, none, $a_6$), ($a_7$, $a_8$, none))
for (i, row) in m.enumerate() {
  for (j, v) in row.enumerate() {
    if v != none {
      content((j * .8, -i * .8), v, frame: "circle", padding: .05,
        stroke: blue)
    }
  }
}
```.text,
```
let m = ((1, 2, none), (4, none, 6), (none, none, 9))
for (i, row) in m.enumerate() {
  for (j, v) in row.enumerate() {
    content((j * .9, -i * .5), if v == none [--] else [#v $m^2$])
  }
}
```.text)

=== Tables and math matrices
#examples(
```
content((0, 0), table(columns: (2cm, 2cm), stroke: blue,
  [aaa], [bbb], [ccc], [], [eee], [fff]))
```.text,
```
content((0, 0), table(columns: (1cm, 2cm), stroke: blue,
  [1], [aaa \ bbb \ ccc], [2], [ddd]))
```.text)
#variants("content((0, 0), $mat(delim: VALUE, a_1, a_2, a_3; a_4, a_5, a_6; a_7, a_8, a_9)$)",
  q("(", "[", "{", "|", "‖") + ("#none",), columns: 3)
Braces beside any content are in #see(<decorations>).
#unported[`ampersand replacement`][Typst code has no active `&`.]

== Chains
#manual("basics/coordinate-systems#relative", label: "relative coordinates")
#unported[`chains` library][A loop places each element relative to the previous one; `line` joins them by name.]
#variants(```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
content((0, 0), [A], name: "n0")
for (i, t) in ("B", "C", "D").enumerate() {
  content((rel: VALUE, to: "n" + str(i)), t, name: "n" + str(i + 1))
}
```.text, ("(1, 0)", "(0, -1)", "(-1, 0)", "(30deg, 1)"), length: .8cm)

=== Changing direction
#examples(```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
let steps = ((1.2, 0), (0, -1), (0, -1), (1.2, 0))
content((0, 0), [A], name: "n0")
for (i, s) in steps.enumerate() {
  content((rel: s, to: "n" + str(i)), "BCDE".at(i), name: "n" + str(i + 1))
}
```.text)

=== Placed on a curve
#examples(```
for i in range(1, 13) {
  content((90deg - i * 30deg, 1.5), [#i], name: "h" + str(i),
    frame: "circle", stroke: none)
}
line("h10", (0, 0), "h2", stroke: blue)
```.text)
With `stroke: none` the frame is invisible but still stops the line.

=== Joining
#examples(
```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
let names = ("A", "B", "C", "D")
for (x, n) in names.enumerate() { content((x * 1.2, 0), n, name: n) }
for (a, b) in names.windows(2) { line(a, b, mark: (end: "straight")) }
```.text,
```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
for (i, n) in ("a", "b", "c", "d", "e", "f").enumerate() {
  content((calc.rem(i, 3) * 1.2, -calc.quo(i, 3)), upper(n), name: n)
}
for (a, b) in ("a", "b", "d", "c", "f", "e").windows(2) {
  line(a, b, stroke: red, mark: (end: "straight"))
}
```.text)

=== Branches
#examples(```
set-style(content: (frame: "rect", padding: .1, stroke: blue))
for (x, n) in ("A", "B", "C").enumerate() { content((x * 1.2, 0), n, name: n) }
for y in range(1, 4) {
  content((rel: (0, -y * .8), to: "B"), [#y], name: "B-" + str(y))
}
line("C", "B-1")
line("C", "B-3")
```.text)
For trees, see #see(<loops-trees>).
