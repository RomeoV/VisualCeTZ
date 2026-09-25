#!/usr/bin/env bash
# Builds docs/visual-cetz.pdf and docs/index.html, which GitHub Pages serves.
set -euo pipefail
cd "$(dirname "$0")"
typst compile --format png --ppi 150 assets/picture.typ assets/picture.png
typst compile visual-cetz.typ docs/visual-cetz.pdf
typst compile --features html --format html visual-cetz.typ docs/index.html
