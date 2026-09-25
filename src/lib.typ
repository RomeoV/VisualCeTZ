#import "@preview/cetz:0.5.2"

#let accent = maroon
#let rule = silver
#let scope = (cetz: cetz) + dictionary(cetz.draw)

// HTML export drops layout-only content, so pictures become inline SVG and layout uses HTML elements.
#let _html(html-version, paged-version) = context if target() == "html" { html-version() } else { paged-version() }
#let pic(it) = _html(() => html.frame(it), () => it)
#let vstack(..items, spacing: 5pt) = _html(() => html.elem("div", items.pos().join()), () => stack(spacing: spacing, ..items))

#let _badge(url, body, hue) = _html(() => html.elem("a", attrs: (href: url, class: "badge"), body),
  () => link(url, box(fill: hue.lighten(85%), stroke: 0.5pt + hue, inset: (x: 4pt, y: 2pt),
    radius: 2pt, text(8pt, weight: "bold", fill: hue.darken(20%), body))))
// Sticky, so a badge stays on the page of the table it documents.
#let _badge-row(badge) = _html(() => html.elem("p", attrs: (class: "badges"), badge),
  () => block(sticky: true, width: 100%, align(center, badge)))

// Badge linking to the CeTZ manual; `path` mirrors `docs/` in the CeTZ tree.
#let manual-badge(path, label: none) = _badge("https://cetz-package.github.io/docs/" + path + "/",
  [CeTZ manual: #if label == none { path } else { label }], maroon)
#let manual(..args) = _badge-row(manual-badge(..args))
// Badge linking to the Typst reference, for plain-Typst features.
#let typst-manual(path, label) = _badge-row(_badge("https://typst.app/docs/reference/" + path,
  [Typst manual: #label], blue))

// Render a canvas body given as source text.
#let render(code, length: 1cm) = pic(cetz.canvas(length: length, eval(code, mode: "code", scope: scope)))

#let _code(src) = raw(src.trim(), lang: "typc")
#let _table(columns, align: center + horizon, ..cells) = {
  set table.cell(breakable: false)
  table(columns: columns, stroke: 0.5pt + rule, inset: 5pt, align: align, ..cells)
}

// One template, several values: `template` contains `VALUE`; each cell renders it with one value.
#let variants(template, values, columns: 4, length: 1cm, prelude: "") = {
  let cells = values.map(v => {
    let v = str(v)
    vstack(render(prelude + template.replace("VALUE", v), length: length),
      text(8pt, fill: accent, raw(v)))
  })
  let n = calc.min(columns, values.len())
  // Bottom alignment keeps the value labels on one line when pictures differ in height.
  _table((1fr,) * n, align: center + bottom, table.header(table.cell(colspan: n, align: left, _code(template))), ..cells)
}

// Rows of render | code.
#let examples(..codes, length: 1cm, prelude: "") = _table((auto, 1fr),
  ..codes.pos().map(c => (render(prelude + c, length: length), table.cell(align: left, _code(c)))).flatten())

// A feature with no CeTZ equivalent; say what to do instead.
#let unported(what, instead) = _html(() => html.elem("aside", attrs: (class: "unported"))[*Not in CeTZ:* #what. #instead],
  () => block(sticky: true, stroke: (left: 2pt + gray), inset: (left: 8pt, y: 3pt),
    text(9pt, fill: gray)[*Not in CeTZ:* #what. #instead]))

// Cross-reference that still compiles when the target chapter is not included.
#let see(target) = context if query(target).len() > 0 { ref(target) } else { raw(str(target)) }
