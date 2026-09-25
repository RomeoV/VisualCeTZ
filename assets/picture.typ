// Sample image for the image-fill and picture-in-canvas examples.
#import "@preview/cetz:0.5.2"
#set page(width: auto, height: auto, margin: 2mm, fill: white)
#cetz.canvas({
  import cetz.draw: *
  for (i, c) in (red, eastern, yellow).enumerate() {
    circle((i * 120deg + 90deg, .6), radius: 1, fill: c.transparentize(40%), stroke: none)
  }
})
