#!/usr/bin/env bash
# Builds the PDF and the GitHub Pages HTML (docs/index.html).
set -euo pipefail
cd "$(dirname "$0")"
typst compile --format png --ppi 150 assets/picture.typ assets/picture.png
typst compile visual-cetz.typ visual-cetz.pdf
typst compile --features html --format html visual-cetz.typ docs/index.html
