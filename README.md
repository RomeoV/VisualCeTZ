# Visual CeTZ

**[Read it online](https://romeov.github.io/VisualCeTZ/)** · **[PDF](visual-cetz.pdf)**

One picture per command or parameter for [CeTZ](https://cetz-package.github.io/) 0.5.2, the drawing package for [Typst](https://typst.app/).

This is an adaptation of Jean Pierre Casteleyn's fantastic [_Visual TikZ_](https://ctan.org/pkg/visualtikz) ([PDF](https://mirrors.ctan.org/info/visualtikz/VisualTikZ.pdf), LPPL 1.3), which does the same for TikZ.
Its structure, section order, and choice of examples shaped every chapter here. The CeTZ code and pictures are new.
Features that CeTZ does not have are marked _Not in CeTZ_, with the closest replacement.

Every picture is rendered from the code printed next to it, and every section links to its page in the CeTZ manual:

![Sections 1.1.1 and 1.1.2](assets/readme-example.png)

## Build

With Typst 0.15 or later:

```sh
./build.sh
```

This writes `visual-cetz.pdf` and `docs/index.html`, which GitHub Pages serves. The HTML export uses Typst's experimental `html` feature.
