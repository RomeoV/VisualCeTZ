#import "lib.typ": *

= Loops and trees <loops-trees>

// Keep each badge on the page of the table it documents.

// Rows of expression | resulting array.
#let arrays(..exprs) = table(columns: (1fr, 1fr), stroke: 0.5pt + rule, inset: 5pt, align: left + horizon,
  ..exprs.pos().map(e => (raw(e, lang: "typc"), eval(e, mode: "code").map(v => [#v]).join([, ]))).flatten())

== Loops

=== One variable
#typst-manual("scripting/#loops", "loops")
#examples(length: .6cm,
  "for x in range(1, 11) {\n  circle((x, 0), radius: .4, fill: eastern)\n}")

=== Two variables
#typst-manual("scripting/#bindings", "destructuring")
#examples(length: .6cm,
  "for (x, t) in range(1, 11).zip(range(90, -1, step: -10)) {\n  let fill = eastern.lighten(t * 1%)\n  circle((x, 0), radius: .5, fill: fill)\n}",
  "for (x, c) in (\n  (1, red),\n  (3, teal),\n  (5, blue),\n) {\n  let ball = gradient.radial(white, c, center: (30%, 30%))\n  circle((x, 0), fill: ball)\n}")

=== Arrays with a step
#typst-manual("foundations/array/#definitions-range", "range")
#examples(length: .8cm,
  "for x in (..range(1, 5), ..range(7, 11)) {\n  for y in range(1, 4) {\n    rect((x - .5, y - .5), (rel: (1, 1)),\n      stroke: eastern)\n    content((x, y), [#x,#y])\n  }\n}")
#arrays(
  "range(1, 7)",
  "range(1, 12, step: 2)",
  "range(90, 76, step: -2).map(str.from-unicode)",
  "range(1, 8).map(n => $2^#n$)",
  "range(7).map(i => i / 2)",
  "\"ABCDEFGH\".clusters().map(l => $#l _1$)",
)

=== Calculation on the variable
#manual("api/draw-functions/shapes/merge-path", label: "merge-path")
#examples(length: .6cm,
  "let petal(a, r, c) = merge-path(fill: c, stroke: none, {\n  bezier((0, 0), (a, r), (a + 10deg, r))\n  bezier((), (0, 0), (a - 10deg, r))\n})\nfor a in range(10, 370, step: 20) { petal(a * 1deg, 3, eastern) }\nfor a in range(0, 360, step: 20) { petal(a * 1deg, 2, red) }")

=== Nested loops
#typst-manual("scripting/#loops", "loops")
#examples(length: .8cm,
  "let pts = for x in (1, 2, 3) { for y in (0, 1, 2) { ((x, y),) } }\nline((0, 0), ..pts, stroke: eastern)\nfor p in pts { content(p, text(fill: red)[X]) }",
  "let pts = for y in (0, 1, 2) { for x in (1, 2, 3) { ((x, y),) } }\nline((0, 0), ..pts, stroke: eastern)\nfor p in pts { content(p, text(fill: red)[X]) }")

== Turtle graphics
#manual("basics/coordinate-systems#relative", label: "relative coordinates")
#unported([the `turtle` library], [Chain relative polar steps `(rel: (angle, length))` in one `line`; a loop turns the heading. For bent steps (`how`), draw each step with `arc-through`.])
#variants("line((0, 0), (rel: VALUE), stroke: 3pt + eastern)",
  ("(90deg, 1)", "(135deg, 1)", "(180deg, 1)", "(45deg, 1)", "(0deg, 1)"),
  columns: 5, length: .8cm, prelude: "grid((-1, -1), (1, 1), stroke: silver)\n")
#examples(length: .7cm,
  "let h = 90deg\nlet steps = ()\nfor (turn, d) in ((-90deg, 2), (90deg, 1), (90deg, 1)) {\n  h += turn\n  steps.push((rel: (h, d)))\n}\nline((0, 0), ..steps, stroke: 3pt + eastern, mark: (end: \">\"))",
  "line((0, 0), ..range(5).map(i => (rel: (-i * 144deg, 2))), close: true,\n  stroke: eastern, fill: red.lighten(80%))",
  "line((0, 0), ..range(1, 26).map(i => (rel: (90deg - i * 120deg, i / 5))), stroke: eastern)")

== Trees
#manual("libraries/tree", label: "tree library")
Examples below run after `import cetz.tree` and share
#raw("let family = ([root], [a], ([b], [b1], [b2]), [c])", lang: "typc").

#let family = "import cetz.tree\nlet family = ([root], [a], ([b], [b1], [b2]), [c])\n"

=== Structure
#manual("api/libraries/tree/tree", label: "tree")
#examples(length: .8cm, prelude: "import cetz.tree\n",
  "tree.tree(([root], [a], ([b], [b1], [b2]), [c]))",
  "tree.tree((none, none, (none, none, none), none),\n  draw-node: _ => circle((0, 0), radius: .08, fill: red))",
  "tree.tree(([root], ..(\"a\", \"b\", \"c\", \"d\")))")

=== Direction
#manual("api/libraries/tree/tree#direction", label: "direction")
#variants("tree.tree(family, direction: VALUE)", ("\"down\"", "\"up\"", "\"left\"", "\"right\""),
  length: .6cm, prelude: family)
#variants("rotate(VALUE)\ntree.tree(family, direction: \"right\")", ("-30deg", "30deg", "45deg", "135deg"),
  length: .6cm, prelude: family)
#unported([per-child `grow` and the mirrored `grow'`], [Draw an odd child outside the tree and `line` it to the parent's anchor; reverse a child array to mirror its order.])

=== Level distance
#manual("api/libraries/tree/tree#grow", label: "grow")
#variants("tree.tree(family, grow: VALUE)", ("0.2", "1", "2"), columns: 3, length: .6cm, prelude: family)

=== Sibling distance
#manual("api/libraries/tree/tree#spread", label: "spread")
#variants("tree.tree(family, spread: VALUE)", ("0.2", "1", "2"), columns: 3, length: .6cm, prelude: family)
#examples(length: .6cm, prelude: "import cetz.tree\n",
  "tree.tree(([root], [a], ([b], [b1], [b2]), ([c], [c1], [c2])), spread: .5)")
#unported([`level distance` and `sibling distance` per level or per child], [`grow` and `spread` apply to the whole tree. The layout packs subtrees tidily, so they never overlap.])

=== Node shapes
#manual("api/libraries/tree/tree#drawnode", label: "draw-node")
#variants("tree.tree(family, draw-node: n => content((0, 0), n.content, padding: .1, VALUE))",
  ("frame: \"rect\"", "frame: \"circle\"", "frame: \"rect\", stroke: none",
   "frame: \"rect\", stroke: (dash: \"dashed\")", "frame: \"rect\", stroke: none, fill: aqua",
   "frame: \"circle\", stroke: red, fill: red.lighten(80%)"),
  columns: 3, length: .6cm, prelude: family)
#examples(length: .7cm, prelude: family,
  "tree.tree(family, direction: \"right\", draw-node: n => {\n  set-style(fill: eastern.lighten(80%), stroke: eastern)\n  if n.depth == 0 { n-star((0, 0), 12, radius: .8) }\n  else if n.children == () { circle((0, 0), radius: (.45, .3)) }\n  else { polygon((0, 0), 4, radius: .5) }\n  content((0, 0), n.content)\n})")

=== Node names
#manual("api/libraries/tree/tree#name", label: "name")
#examples(length: .8cm, prelude: family,
  "tree.tree(family, name: \"t\", grow: 1.5, spread: 1.5)\nfor a in (\"0\", \"0-0\", \"0-1\", \"0-1-0\", \"0-1-1\", \"0-2\") {\n  content((rel: (0, -.45), to: \"t.\" + a), text(fill: blue, raw(a)),\n    frame: \"rect\", stroke: none, fill: white)\n}\nline(\"t.g0-0\", \"t.g0-1\", stroke: 2pt + red)")

=== Missing nodes
#manual("api/libraries/tree/tree#drawedge", label: "draw-edge")
#examples(length: .8cm, prelude: "import cetz.tree\n",
  "tree.tree(([0], [1], [2], [3], none, [5], [6]),\n  draw-edge: (p, c) => if c.content != none {\n    line(p.group-name, c.group-name)\n  })")

=== Edge anchors
#manual("api/libraries/tree/tree#drawedge", label: "draw-edge")
#variants("tree.tree(family, draw-edge: (p, c) =>\n  line(p.group-name + VALUE, c.group-name + \".north\", stroke: red))",
  ("\".south\"", "\".south-east\"", "\".east\""), columns: 3, length: .6cm, prelude: family)
#variants("tree.tree(family, draw-edge: (p, c) =>\n  line(p.group-name + \".south\", c.group-name + VALUE, stroke: red))",
  ("\".north\"", "\".north-west\"", "\".west\""), columns: 3, length: .6cm, prelude: family)

=== Edge style
#manual("api/libraries/tree/tree#drawedge", label: "draw-edge")
#examples(length: .6cm, prelude: family,
  "tree.tree(family, draw-edge: (p, c) =>\n  line(p.group-name, c.group-name, stroke: 2pt + red))",
  "tree.tree(family, draw-edge: (p, c) => {\n  let s = if c.name == \"0-1-0\" { 2pt + red } else { eastern }\n  line(p.group-name, c.group-name, stroke: s)\n})",
  "tree.tree(family, draw-edge: (p, c) => {\n  if c.name != \"0-1-1\" { line(p.group-name, c.group-name) }\n})",
  "tree.tree(family, draw-edge: none)")

=== Edge labels
#manual("api/draw-functions/shapes/content", label: "content")
#variants("tree.tree(([root], [leaf]), grow: 1.5, draw-edge: (p, c) => {\n  line(p.group-name, c.group-name)\n  content((p.group-name, 50%, c.group-name), text(fill: red)[label], VALUE)\n})",
  ("anchor: \"east\", padding: .1", "anchor: \"west\", padding: .1", "frame: \"rect\", fill: white, padding: .05"),
  columns: 3, length: .8cm, prelude: "import cetz.tree\n")
#variants("tree.tree(([root], [leaf]), grow: 1.5, draw-edge: (p, c) => {\n  line(p.group-name, c.group-name)\n  content((p.group-name, VALUE, c.group-name), text(fill: red)[label], anchor: \"west\")\n})",
  ("20%", "50%", "80%"), columns: 3, length: .8cm, prelude: "import cetz.tree\n")

=== Edge paths
#manual("basics/coordinate-systems#perpendicular", label: "perpendicular")
#variants("tree.tree(family, draw-edge: (p, c) => {\n  let (a, b) = (p.group-name + \".south\", c.group-name + \".north\")\n  VALUE\n})",
  ("bezier(a, b, (rel: (0, -.6), to: a), (rel: (0, .6), to: b))",
   "line(a, (a, \"-|\", b), b)",
   "bezier(a, b, (b, \"|-\", a))",
   "let m = (a, 50%, b)\n  line(a, (a, \"|-\", m), (b, \"|-\", m), b)"),
  columns: 2, length: .6cm, prelude: family)
#examples(length: .6cm, prelude: family,
  "tree.tree(family, direction: \"right\", draw-edge: (p, c) => {\n  let (a, b) = (p.group-name + \".east\", c.group-name + \".west\")\n  let m = (a, 50%, b)\n  line(a, (m, \"|-\", a), (m, \"|-\", b), b, stroke: blue)\n})")

=== Radial and custom child positions
#block(breakable: false)[
#unported([`grow cyclic`, `sibling angle`, `clockwise from` and `grow via three points`], [Place the children in a loop, at polar coordinates `(angle, radius)` or at linear steps `(i * dx, dy)`.])
#examples(length: .8cm,
  "content((0, 0), [root], name: \"r\", padding: .1)\nfor a in (30, 0, -30, -60) {\n  content((a * 1deg, 1.6), $#a$, name: \"c\")\n  line(\"r\", \"c\", stroke: eastern)\n}")
]
