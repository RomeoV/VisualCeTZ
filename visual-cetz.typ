#import "src/lib.typ": *

#let repo = "https://github.com/RomeoV/VisualCeTZ"
#let visual-tikz = "https://ctan.org/pkg/visualtikz"

#set document(title: "Visual CeTZ")
#set page(paper: "a4", margin: 2cm, numbering: "1")
#set text(font: ("Helvetica Neue", "Arial"), size: 10pt, fill: black)
#set heading(numbering: "1.1")
#show heading: set text(fill: maroon)
#show link: set text(fill: blue)
#show raw: set text(font: ("Menlo", "DejaVu Sans Mono"), size: 8pt)

#let chapters = (
  "02-paths", "04-marks", "06-coordinates", "07-content", "10-structure",
  "17-shapes", "18-decorations", "22-plots", "26-loops-trees", "99-not-ported",
)
#let only = sys.inputs.at("chapter", default: none)

#context if target() == "html" {
  html.elem("style", read("src/html.css"))
}

#if only == none {
  let front = [
    One picture per command or parameter, for CeTZ 0.5.2.

    Adapted from Jean Pierre Casteleyn's fantastic work _Visual TikZ_ [1], which does the same for TikZ.
    Its structure, section order and examples inspired every chapter here; the CeTZ code and pictures are new.
    Source: #link(repo).

    [1] Jean Pierre Casteleyn, _Visual TikZ_, version 0.65, 2018.
    #link(visual-tikz)[CTAN: visualtikz], #link("https://mirrors.ctan.org/info/visualtikz/VisualTikZ.pdf")[PDF].
    LaTeX Project Public License 1.3.
  ]
  context if target() == "html" {
    html.elem("h1")[Visual CeTZ]
    front
  } else {
    align(center, text(28pt, weight: "bold", fill: maroon)[Visual CeTZ])
    front
  }
  outline(depth: 2)
  pagebreak()
}

#for ch in chapters {
  if only == none or ch.starts-with(only) {
    include "src/" + ch + ".typ"
  }
}
