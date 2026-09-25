#!/usr/bin/env bash
# Builds docs/visual-cetz.pdf, docs/index.html and one PNG per page in docs/pages/, which GitHub Pages serves.
set -euo pipefail
cd "$(dirname "$0")"
typst compile --format png --ppi 150 assets/picture.typ assets/picture.png
typst compile visual-cetz.typ docs/visual-cetz.pdf
typst compile --features html --format html visual-cetz.typ docs/index.html
rm -rf docs/pages && mkdir docs/pages
typst compile --format png --ppi 100 visual-cetz.typ 'docs/pages/{0p}.png'
