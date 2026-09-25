#import "lib.typ": *

= Shapes and text <shapes>

CeTZ has no node shapes. Draw the shape, then place `content` on one of its anchors.

== Framed content

#manual("api/draw-functions/shapes/content", label: "content")
#variants(```
grid((0, 0), (2, 2), stroke: silver)
content((1, 1), [text], padding: .1, fill: red.lighten(80%), VALUE)
```.text, (
  "frame: \"rect\", stroke: none",
  "frame: \"rect\", stroke: red",
  "frame: \"circle\", stroke: none",
  "frame: \"circle\", stroke: red",
))

`fill` and `stroke` apply only when `frame` is set.

=== Frame style
#variants(```
content((0, 0), [text], frame: "rect", padding: .1, VALUE)
```.text, (
  "stroke: 2pt + blue",
  "stroke: (dash: \"dashed\")",
  "stroke: red",
  "angle: 45deg",
  "fill: gradient.radial(aqua, white)",
  "wrap: text.with(red)",
), columns: 3)

`content` frames have no corner radius and no double stroke. Frame the named element with `rect-around`, or pass a Typst `box` as the body:

#examples(
  ```
content((0, 0), [text], name: "t", padding: .1)
rect-around("t", radius: .1, stroke: blue)
```.text,
  ```
content((0, 0), [text], name: "t", padding: .1)
rect-around("t", stroke: blue)
rect-around("t", padding: .06, stroke: blue)
```.text,
  ```
content((0, 0), box(fill: red.lighten(80%), stroke: blue, inset: 4pt, radius: 4pt)[text])
```.text,
)

=== Padding
#variants(```
content((0, 0), [text], frame: "rect", fill: eastern.lighten(80%), padding: VALUE)
```.text, (
  "0", ".1", ".5", "(x: .5)", "(y: .5)", "(top: 1)", "(bottom: 1)", "(.1, .6, .3, 0)",
))

The default padding is `0`. `top` and `bottom` replace TikZ `text height` and `text depth`. Arrays follow CSS order: `(y, x)`, `(top, x, bottom)`, `(top, right, bottom, left)`. Dictionaries take `top`, `bottom`, `left`, `right`, `x`, `y`, `rest`.

=== Outer separation
#unported([`outer sep`: anchors always lie on the frame], [Move the coordinate away from the anchor instead, e.g. `("a.east", -.3, "a.center")` is 0.3 beyond `a.east`.])
#examples(```
content((0, 0), [text], name: "a", frame: "rect", padding: .1)
line(("a.east", -.3, "a.center"), (rel: (1, 0)), mark: (end: ">"))
line(("a.south", -.3, "a.center"), (rel: (0, -.6)), mark: (end: ">"))
```.text)

=== Fixed size
Two coordinates set the frame; the body fills it. A circle of given size is a `circle` with `content` on top.
#variants(```
content((0, 0), (rel: VALUE), align(center + horizon)[text],
  frame: "rect", fill: eastern.lighten(80%), stroke: blue)
```.text, ("(1, 1.5)", "(3, .5)", "(1.5, 1.5)"), columns: 3)
#examples(```
circle((0, 0), radius: .75, name: "c",
  fill: eastern.lighten(80%), stroke: blue)
content("c", [text])
```.text)

== Built-in shapes
#manual("api/draw-functions/shapes", label: "shapes")
#variants(```
set-style(fill: green.lighten(70%), stroke: teal)
VALUE
content((0, 0), [text])
```.text, (
  "rect((-.7, -.4), (.7, .4))",
  "rect((-.7, -.4), (.7, .4), radius: .15)",
  "circle((0, 0), radius: .6)",
  "circle((0, 0), radius: (.9, .45))",
  "polygon((0, 0), 4, radius: (.9, .6))",
  "polygon((0, 0), 5, radius: .75, angle: 90deg)",
  "n-star((0, 0), 5, radius: .9, angle: 54deg)",
  "arc((0, 0), start: 0deg, stop: 180deg, radius: .9, mode: \"CLOSE\", anchor: \"center\")",
  "arc((0, 0), start: -45deg, stop: 45deg, radius: 1.5, mode: \"PIE\", anchor: \"center\")",
), columns: 3)

=== Star
#manual("api/draw-functions/shapes/n-star", label: "n-star")
#variants(```
n-star((0, 0), VALUE, radius: .8, fill: green.lighten(70%), stroke: teal)
```.text, ("4", "5", "6", "8"))
#variants(```
n-star((0, 0), 5, angle: 54deg, radius: .8, VALUE)
```.text, ("inner-radius: 20%", "inner-radius: 50%", "inner-radius: 70%", "show-inner: true"))

=== Regular polygon
#manual("api/draw-functions/shapes/polygon", label: "polygon")
#variants(```
polygon((0, 0), VALUE, radius: .7, fill: green.lighten(70%), stroke: teal)
```.text, ("3", "4", "5", "6", "7", "8"), columns: 6)
#variants(```
polygon((0, 0), 4, radius: VALUE, fill: green.lighten(70%), stroke: teal)
content((0, 0), [text])
```.text, ("(.6, .6)", "(.9, .5)", "(1.2, .45)", "(1.5, .4)"))

=== Arc, segment and sector
#manual("api/draw-functions/shapes/arc", label: "arc")
#variants(```
arc((0, 0), start: 30deg, stop: 150deg, fill: green.lighten(70%), mode: VALUE)
```.text, ("\"OPEN\"", "\"CLOSE\"", "\"PIE\""), columns: 3)
#variants(```
arc((0, 0), start: 0deg, delta: VALUE, radius: .8, mode: "PIE", fill: green.lighten(70%))
```.text, ("45deg", "90deg", "180deg", "270deg"))

=== Rounded rectangle
#manual("api/draw-functions/shapes/rect", label: "rect")
#variants(```
rect((0, 0), (2, 1), fill: green.lighten(70%), radius: VALUE)
```.text, (
  "0", ".2", "50%", "(rest: (20%, 50%))",
  "(north: 50%)", "(west: 50%)", "(north-east: 50%)", "(south-west: 0, rest: .3)",
))

== Shapes from lines
#manual("api/draw-functions/shapes/line", label: "line")
A closed `line` is any polygon; its `centroid` anchor centers the text. The examples in this and the next sections start with `set-style(fill: green.lighten(70%), stroke: teal)`.
#let shape-prelude = "set-style(fill: green.lighten(70%), stroke: teal)\n"
#examples(prelude: shape-prelude,
  ```
line((-1.4, -.4), (1.4, -.4), (.9, .4), (-.9, .4), close: true, name: "s")
content("s.centroid", [trapezium])
```.text,
  ```
line((-.8, -1), (1.6, 0), (-.8, 1), close: true, name: "s")
content("s.centroid", [triangle])
```.text,
  ```
line((0, .5), (.8, 0), (0, -1.2), (-.8, 0), close: true, name: "s")
content("s.centroid", [kite])
```.text,
  ```
line((1.4, 0), (-.8, .8), (-.3, 0), (-.8, -.8), close: true)
content((.35, 0), [dart])
```.text,
  ```
polygon((0, 0), 8, radius: (1.3, .6), angle: 22.5deg)
content((0, 0), [chamfered])
```.text,
  ```
boolean(op: "difference",
  { rect((-1, -.4), (1, .4)) }, { circle((-1, 0), radius: .3) })
content((.15, 0), [concave])
```.text,
  ```
rotate(20deg)
line((-1.4, -.4), (1.4, -.4), (.9, .4), (-.9, .4), close: true, name: "s")
content("s.centroid", [rotated])
```.text,
)

=== Cylinder and tape
#manual("api/draw-functions/shapes/merge-path", label: "merge-path")
#examples(prelude: shape-prelude,
  ```
merge-path(close: true, {
  line((1, .5), (-1, .5))
  arc((), start: 90deg, delta: 180deg, radius: (.2, .5))
  line((), (1, -.5))
})
circle((1, 0), radius: (.2, .5), fill: green.lighten(40%))
content((0, 0), [cylinder])
```.text,
  ```
merge-path(close: true, {
  bezier((-1, .4), (1, .4), (-.4, .7), (.4, .1))
  line((), (1, -.4))
  bezier((), (-1, -.4), (.4, -.7), (-.4, -.1))
})
content((0, 0), [tape])
```.text,
)

== Symbol shapes
#manual("api/draw-functions/shapes/boolean", label: "boolean")
#examples(prelude: shape-prelude,
  ```
circle((0, 0), radius: .6, name: "c")
line("c.north-east", "c.south-west")
content((0, 0), [text])
```.text,
  ```
circle((0, 0), radius: .6, name: "g")
line("g.south-east", (rel: (.6, -.6)), stroke: 3pt + teal)
content((0, 0), [text])
```.text,
  ```
boolean(op: "union", { circle((0, 0), radius: (1.2, .6)) }, {
  for i in range(10) {
    circle((angle: i * 36deg, radius: (1.2, .6)), radius: .3)
  }
})
content((0, 0), [cloud])
```.text,
  ```
n-star((0, 0), 17, radius: 1.2, inner-radius: 75%)
content((0, 0), [starburst])
```.text,
  ```
line((-1, -.4), (.7, -.4), (1, 0), (.7, .4), (-1, .4), close: true)
content((-.1, 0), [signal])
```.text,
)
#unported([`random starburst`; `cloud puffs` and similar shape options], [Compute the points in a loop, as for the cloud.])

== Arrow shapes
#examples(prelude: shape-prelude,
  ```
line((0, -.25), (1.4, -.25), (1.4, -.5), (2, 0), (1.4, .5), (1.4, .25),
  (0, .25), close: true)
content((.7, 0), [text])
```.text,
  ```
line((-1, 0), (-.5, .5), (-.5, .25), (.5, .25), (.5, .5), (1, 0),
  (.5, -.5), (.5, -.25), (-.5, -.25), (-.5, -.5), close: true)
content((0, 0), [text])
```.text,
)
#unported([`arrow box`], [Frame the content and draw a line with a mark from each side.])
#examples(```
content((0, 0), [text], name: "t", frame: "rect", padding: .1)
for a in ("north", "south", "east", "west") {
  line("t." + a, ("t." + a, -.5, "t.center"),
    mark: (end: "triangle", fill: blue))
}
```.text)

== Callouts
#manual("api/draw-functions/shapes/boolean", label: "boolean")
The pointer is a triangle joined to the body with `boolean(.., op: "union")`. Its tip is an absolute coordinate.
#examples(prelude: shape-prelude,
  ```
grid((0, 0), (3, 2), stroke: silver)
boolean(op: "union",
  { rect((1.4, .2), (2.8, .8)) },
  { line((1.8, .5), (2.2, .5), (1, 1.8), close: true) })
content((2.1, .5), [text])
```.text,
  ```
grid((0, 0), (3, 2), stroke: silver)
boolean(op: "union",
  { circle((2, .5), radius: (.8, .35)) },
  { line((1.8, .3), (2, .7), (.3, 1.7), close: true) })
content((2, .5), [text])
```.text,
  ```
boolean(op: "union", { circle((0, 0), radius: (1.2, .6)) }, {
  for i in range(10) {
    circle((angle: i * 36deg, radius: (1.2, .6)), radius: .3)
  }
})
content((0, 0), [text])
circle((1.3, -.9), radius: .15)
circle((1.6, -1.2), radius: .08)
```.text,
)

== Cross out and strike out
#examples(
  ```
content((0, 0), [text], name: "t")
line("t.north-west", "t.south-east", stroke: red)
line("t.south-west", "t.north-east", stroke: red)
```.text,
  ```
content((0, 0), [text], name: "t")
line("t.south-west", "t.north-east", stroke: red)
```.text,
)

== Multi-part content
#manual("api/draw-functions/shapes/content", label: "content")
#unported([`rectangle split`, `circle split`, `\nodepart`], [Put a Typst `table` in `content`, or split a shape with a `line`.])
#variants(```
content((0, 0), table(VALUE, [text 1], [text 2], [], [text 3]))
```.text, (
  "columns: 1",
  "columns: 4",
  "columns: 1, stroke: none",
  "columns: 1, rows: (auto, 1cm)",
  "columns: 1, fill: (_, y) => eastern.lighten(90% - y * 20%)",
  "columns: 2cm, align: (_, y) => (center, left, right, right).at(y)",
), columns: 3)
#examples(
  ```
content((0, 0), frame: "rect", padding: .1,
  table(columns: 1, stroke: none, [text 1], [text 2a \ text 2b], [text 3]))
```.text,
  ```
circle((0, 0), radius: .8, name: "c", fill: green.lighten(70%))
line("c.west", "c.east")
content((0, .3), [upper])
content((0, -.3), [lower])
```.text,
  ```
circle((0, 0), radius: 1.2, name: "c", fill: green.lighten(70%))
line((name: "c", anchor: 70deg), (name: "c", anchor: 250deg))
content((-.45, .4), [upper])
content((.45, -.45), [lower])
```.text,
)

== Text attributes
#manual("api/draw-functions/shapes/content", label: "content")

=== Width and alignment
#variants(```
content((0, 0), box(width: 2cm, VALUE),
  frame: "rect", fill: eastern.lighten(80%), stroke: none)
```.text, (
  "lorem(9)", "align(center, lorem(9))", "align(right, lorem(9))", "par(justify: true, lorem(9))",
))
#variants(```
content((0, 0), align(VALUE)[AAA \ BBBBBBBB \ CC], frame: "rect", padding: .1)
```.text, ("left", "center", "right"), columns: 3)
#variants(```
content((0, 0), par(leading: VALUE)[AAA \ BBBBBBBB], frame: "rect", padding: .1)
```.text, ("0.2em", "0.5cm", "1cm"), columns: 3)

=== Colors and fonts
#variants(```
content((0, 0), text(VALUE)[Text.])
```.text, (
  "red", "style: \"italic\"", "weight: \"bold\"", "font: \"DejaVu Sans Mono\"",
  "tracking: 2pt", "stroke: .3pt + blue",
), columns: 6)
#variants(```
content((0, 0), text(size: VALUE)[Text.])
```.text, ("6pt", "8pt", "10pt", "14pt", "20pt", "28pt"), columns: 6)
The `wrap` style applies a function to every content body:
#examples(```
set-style(content: (wrap: text.with(red, weight: "bold")))
content((0, 0), [one])
content((1, 0), [two])
```.text)

== Anchors
#manual("basics/anchors", label: "anchors")

=== Content anchors
#variants(```
content((0, 0), text(20pt)[text], name: "t", frame: "rect", padding: .2)
circle((name: "t", anchor: VALUE), radius: .07, fill: red, stroke: none)
```.text, (
  "\"north-west\"", "\"north\"", "\"north-east\"", "\"text\"",
  "\"west\"", "\"mid-west\"", "\"base-west\"", "\"base\"",
  "\"east\"", "\"mid-east\"", "\"base-east\"", "\"mid\"",
  "\"south-west\"", "\"south\"", "\"south-east\"", "\"center\"",
  "0deg", "120deg", "-60deg", "10%",
))
An angle is a border anchor: the ray from `center` at that angle meets the frame. A ratio or number is a path anchor along the frame, starting at `north-west`. A string anchor can also be written `"t.north"`.

=== Shape anchors
#let anchor-prelude = ```
let compass = ("north", "north-east", "east", "south-east",
  "south", "south-west", "west", "north-west")
let mark-anchors(s, names) = for n in names {
  circle(s + "." + n, radius: .05, fill: red, stroke: none)
  content((s + "." + n, -.4, s + ".center"), text(6pt, fill: maroon, n))
}
```.text + "\n"
The maps below use this helper:
#raw(anchor-prelude.trim(), lang: "typc", block: true)
#examples(prelude: anchor-prelude,
  ```
rect((0, 0), (3, 1.6), name: "s")
mark-anchors("s", compass)
```.text,
  ```
circle((0, 0), radius: (1.5, .8), name: "s")
mark-anchors("s", compass)
```.text,
  ```
polygon((0, 0), 5, radius: 1.2, angle: 90deg, name: "s")
for i in range(5) {
  mark-anchors("s", ("corner-" + str(i), "edge-" + str(i)))
}
```.text,
  ```
line((-1.4, -.4), (1.4, -.4), (.9, .4), (-.9, .4),
  close: true, name: "s")
for n in ("start", "mid", "centroid") {
  circle("s." + n, radius: .05, fill: red, stroke: none)
  content("s." + n, text(6pt, fill: maroon, n),
    anchor: "south", padding: .08)
}
```.text,
  ```
arc((0, 0), start: 0deg, stop: 250deg, radius: 1.2,
  mode: "PIE", name: "s")
mark-anchors("s", ("arc-start", "arc-end", "arc-center",
  "chord-center", "origin"))
```.text,
)
On `rect` and `circle`, an angle anchor is scaled by the aspect ratio, so `45deg` (`north-east`) is a corner of any rect. On `content` the angle is exact.
#unported([`n-star` anchors `corner-i` and `edge-i`: listed, but they panic in 0.5.2], [Use compass or angle border anchors, or polar coordinates from the star's origin.])
