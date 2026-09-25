#import "lib.typ": *

#let lead = block.with(sticky: true)

= Marks <marks>

#let q(..names) = names.pos().map(repr)
#let tint = "eastern.lighten(60%)"
#let arrow(style) = "line((0, 0), (1.4, .8), stroke: 1.5pt + blue,\n  mark: (end: VALUE, scale: 2, fill: " + tint + style + "))"
#let ruled = "grid((0, -1), (2.5, 1), step: .5, stroke: .3pt + silver)\n"
#let ruled-arrow(style) = "line((0, 0), (2, 0), stroke: 1.5pt + blue,\n  mark: (end: VALUE, " + style + ", fill: " + tint + "))"

== Mark symbols

=== Start, end, both ends
#manual("basics/marks#symbol", label: "marks: symbol, start, end")
#variants("line((0, 0), (1.5, .8), stroke: 1pt + blue, mark: VALUE)",
  ("(end: \">\")", "(start: \">\")", "(symbol: \">\")", "(start: \"<\", end: \">\")",
   "(end: \"straight\")", "(end: \"o\")", "(end: \"|\")", "(end: \">>\")"))

=== Symbols
#manual("basics/marks", label: "marks")
#variants(arrow(""), q(..cetz.mark-shapes.names))

Shorthands:
#table(columns: 7, stroke: 0.5pt + rule, inset: 4pt, align: center,
  ..cetz.mark-shapes.mnemonics.pairs().map(((short, (name, flags))) =>
    [#raw(short) \ #text(8pt, fill: accent, raw(name + if flags.at("reverse", default: false) { " reversed" }))]))

`arrows.meta` tips by closest CeTZ shape:
#table(columns: (1fr, auto) * 2, stroke: 0.5pt + rule, inset: 4pt, align: left,
  ..(
    ("Triangle, Latex", "\">\""), ("Stealth", "\">>\""),
    ("Straight Barb", "\"straight\""), ("Classical TikZ Rightarrow", "\"barbed\""),
    ("Arc Barb, Parenthesis", "\")\""), ("Bar", "\"|\""),
    ("Bracket, Tee Barb", "\"]\""), ("Computer Modern Rightarrow, To", "\"barbed\""),
    ("Hooks", "\"hook\""), ("Circle", "\"o\""),
    ("Ellipse", "\"ellipse\""), ("Diamond, Kite, Turned Square", "\"<>\""),
    ("Square, Rectangle", "\"[]\""), ("Rays", "\"+\", \"x\", \"*\""),
  ).map(((tikz, cetz)) => (text(9pt, tikz), text(8pt, fill: accent, raw(cetz)))).flatten())

#unported[Cap tips (`Butt Cap`, `Round Cap`, `Triangle Cap`, `Fast Round`, `Fast Triangle`, `cap angle`)][Set the stroke `cap` of the path, see #see(<paths>).]
#unported[`Implies` and `double` lines][Stroke the path twice, see #see(<paths>).]
#unported[`Rays[n=…]`][Use `"+"`, `"x"` or `"*"`, or draw your own with `register-mark` (@marks-custom).]

=== Several marks
#manual("basics/marks#symbol", label: "marks: symbol")
#examples(
  "line((0, 0), (3, 1), stroke: 1.5pt + blue,\n  mark: (start: \">\", end: \"o\", scale: 2, fill: " + tint + "))",
  "line((0, 0), (3, 1), stroke: 1.5pt + blue,\n  mark: (end: (\"o\", \">\"), scale: 2, fill: " + tint + "))",
  "line((0, 0), (3, 1), stroke: 1.5pt + blue, mark: (scale: 2,\n  end: ((symbol: \"o\", sep: .3, fill: red), \">\", \">\")))",
)

== Mark parameters

=== Distance between marks: `sep`
#manual("basics/marks#sep", label: "marks: sep")
#variants("line((0, 0), (1.5, .8), stroke: 1pt + blue,\n  mark: (end: (\">\", \">\"), sep: VALUE, scale: 2))", ("-0.1", "0", "0.1", "0.3"))
#variants("line((0, 0), (1.5, .8), stroke: 1pt + blue,\n  mark: (end: (VALUE, VALUE), sep: .15, scale: 2))",
  q("straight", "bracket", "hook", "parenthesis", "circle", "diamond", "stealth", "rect"))

=== Length
#manual("basics/marks#length", label: "marks: length")
#variants(ruled-arrow("length: 1, width: .4"),
  q("triangle", "stealth", "curved-stealth", "straight", "barbed", "diamond", "ellipse", "rect"), prelude: ruled)

#lead[A ratio is relative to the stroke thickness. This also holds for `width`, `inset` and `sep`.]
#variants("line((0, 0), (1.5, 0), stroke: VALUE + blue,\n  mark: (end: \">\", length: 600%, width: 500%))", ("0.5pt", "1pt", "2pt", "4pt"))

=== Width
#manual("basics/marks#width", label: "marks: width")
#variants(ruled-arrow("length: .4, width: 1"),
  q("triangle", "straight", "barbed", "bar", "bracket", "diamond", "ellipse", "parenthesis"), prelude: ruled)
#unported[`width'` (width relative to length)][Use `angle`, or compute `width` from `length`.]

=== Inset
#manual("basics/marks#inset", label: "marks: inset")
#variants("line((0, 0), (2, 0), stroke: 1.5pt + blue,\n  mark: (end: \">>\", length: 1, width: .8, inset: VALUE, fill: " + tint + "))",
  ("0", "0.2", "0.5", "0.8"), prelude: ruled)
#variants(ruled-arrow("length: .6, width: .8, inset: .3"), q("stealth", "curved-stealth", "bracket", "hook"), prelude: ruled)

=== Angle
#manual("basics/marks#width", label: "marks: width")
#lead[`angle` is not in the manual. It sets `width` from `length`: $w = 2 l tan(alpha \/ 2)$.]
#variants("line((0, 0), (1.2, .6), stroke: 1pt + blue,\n  mark: (end: \">\", length: .5, angle: VALUE, fill: " + tint + "))",
  ("20deg", "45deg", "60deg", "90deg"))
#variants("line((0, 0), (1.2, .6), stroke: 1pt + blue,\n  mark: (end: \"straight\", length: .5, angle: VALUE))",
  ("20deg", "45deg", "60deg", "90deg"))

=== Scale
#manual("basics/marks#scale", label: "marks: scale")
#variants("line((0, 0), (1.5, 0), stroke: 1pt + blue,\n  mark: (end: \"stealth\", scale: VALUE, fill: " + tint + "))", ("1", "2", "3", "4"))
#unported[`scale length`, `scale width`][Set `length` or `width` directly.]

=== Arc
#manual("basics/marks", label: "marks")
#unported[`arc` of `Arc Barb` and `Hooks`][The `")"` mark reads `angle` as its arc span; the width follows from `angle` and `length`. Keep `angle` below 180deg.]
#variants("line((0, 0), (1.5, 0), stroke: 1pt + blue,\n  mark: (end: \")\", angle: VALUE, scale: 2))", ("40deg", "80deg", "120deg"), columns: 3)

=== Slant
#manual("basics/marks#slant", label: "marks: slant")
#variants("line((0, 0), (2, 0), stroke: 1.5pt + blue,\n  mark: (end: \">>\", length: 1, width: .8, slant: VALUE, fill: " + tint + "))",
  ("0%", "25%", "50%", "100%"), prelude: ruled)
#variants("line((0, 0), (1.5, 0), stroke: 1.5pt + blue,\n  mark: (end: VALUE, scale: 3, slant: 50%, fill: " + tint + "))", q("triangle", "straight", "bracket", "hook", "parenthesis", "circle", "diamond", "rect"))

=== Reverse
#manual("basics/marks#reverse", label: "marks: reverse")
#variants(arrow(", reverse: true"), q("triangle", "stealth", "curved-stealth", "straight", "barbed", "bracket", "hook", "parenthesis"))

=== Harpoon and flip
#manual("basics/marks#harpoon", label: "marks: harpoon, flip")
#lead[`harpoon` keeps one half (TikZ `left`); add `flip` for the other half (`right`, `swap`).]
#let halves = q("triangle", "stealth", "straight", "barbed", "bar", "bracket", "hook", "diamond", "ellipse", "circle")
#variants(arrow(", harpoon: true"), halves, columns: 5)
#variants(arrow(", harpoon: true, flip: true"), halves, columns: 5)

=== Stroke and fill
#manual("basics/styling", label: "styling")
#lead[The mark takes the stroke and fill of its path. Paths have no fill by default, so marks are open. TikZ `open` is `fill: none`.]
#variants(arrow(", stroke: red"), q("triangle", "stealth", "straight", "bracket", "hook", "circle", "diamond", "star"))
#variants("line((0, 0), (1.4, .8), stroke: 1.5pt + blue,\n  mark: (end: \"stealth\", scale: 3, fill: VALUE))",
  ("none", "blue", "red", "red.lighten(60%)"))

=== Cap, join, round, sharp
#manual("basics/styling", label: "styling")
#variants("line((0, 0), (2, 0), stroke: 1pt + blue,\n  mark: (end: \"straight\", scale: 5, stroke: (thickness: 8pt, cap: VALUE)))",
  q("butt", "round", "square"), columns: 3)
#variants("line((0, 0), (2, 0), stroke: 1pt + blue,\n  mark: (end: \"straight\", scale: 5, stroke: (thickness: 8pt, join: VALUE)))",
  q("miter", "round", "bevel"), columns: 3)
TikZ `round` is `stroke: (cap: "round", join: "round")`, `sharp` is `stroke: (cap: "butt", join: "miter")`.

=== Line width
#manual("basics/styling", label: "styling")
#variants("line((0, 0), (1.5, 0), stroke: 4pt + blue,\n  mark: (end: \">\", scale: 3, stroke: VALUE))", ("0.5pt", "1pt", "2pt", "4pt"))
#unported[`line width'` and line widths relative to the path][Give the mark `stroke` an absolute thickness.]

== Placement

=== Marks on curves
#manual("basics/marks#positionsamples", label: "marks: position-samples")
#examples(
  "bezier((0, 0), (3, 1), (1, -1), (2, 1), stroke: blue,\n  mark: (end: \">>\", length: .8, width: .5))",
  "arc((0, 0), start: 0deg, stop: 270deg, radius: .6, stroke: blue,\n  mark: (start: \"|\", end: \">\", scale: 2, fill: red))",
  "hobby((0, 0), (1, 1), (2, 0), (3, 1), stroke: blue,\n  mark: (symbol: \"o\", scale: 2))",
)
#unported[`bending`, `flex`, `quick`][Marks stay straight. CeTZ aligns a mark with the chord between its tip and base on the curve, and shortens curves along the curve. `position-samples` sets the precision.]

=== Position along the path
#manual("basics/marks#pos", label: "marks: pos, offset, anchor, shorten-to")
#variants("line((0, 0), (2, 0), stroke: 1pt + blue, mark: (end: \">\", scale: 2, VALUE))\ncircle((2, 0), radius: .05, fill: red, stroke: none)",
  ("pos: 50%", "offset: .5", "anchor: \"center\"", "anchor: \"base\""))
#variants("line((0, 0), (2.5, 0), stroke: 1pt + blue,\n  mark: (end: (\"o\", \">\", \">\"), scale: 2, shorten-to: VALUE))",
  ("auto", "0", "none"), columns: 3)

=== Standalone mark
#manual("api/draw-functions/shapes/mark", label: "mark")
#examples(
  "grid((-1, -1), (1, 1), stroke: silver)\nmark((0, 0), (1, 1), symbol: \">\", scale: 4,\n  stroke: red, fill: red.lighten(60%))",
  "grid((-1, -1), (1, 1), stroke: silver)\nmark((0, 0), 30deg, \">>\", anchor: \"center\", scale: 4,\n  stroke: blue, fill: eastern)",
)

=== Transformed marks
#manual("basics/marks#transformshape", label: "marks: transform-shape")
#lead[The default is `false` (the manual says `true`).]
#variants("scale(y: .4)\nline((0, 0), (2, 1.5), stroke: blue,\n  mark: (end: \">\", scale: 3, transform-shape: VALUE))", ("false", "true"), columns: 2)

=== Custom marks <marks-custom>
#manual("api/draw-functions/styling/register-mark", label: "register-mark")
#examples(
  "register-mark(\"rays\", style => {\n  for i in range(8) { line((0, 0), (i * 45deg, style.length)) }\n  anchor(\"tip\", (0, 0))\n  anchor(\"base\", (0, 0))\n})\nline((0, 0), (2, 1), stroke: blue, mark: (end: \"rays\", scale: 2))",
)
