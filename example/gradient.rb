require_relative '../lib/rainbow'
require 'pp'

first_color  = Rainbow::Color.new(ChunkyPNG::Color(255, 221, 23), 0)
second_color = Rainbow::Color.new(ChunkyPNG::Color(255, 221, 23), 62)
color_range1 = Rainbow::ColorRange.new(first_color, second_color, 50)

third_color  = Rainbow::Color.new(ChunkyPNG::Color(255, 221, 23), 63)
color_range2 = Rainbow::ColorRange.new(second_color, third_color, 50)

fouth_color  = Rainbow::Color.new(ChunkyPNG::Color(255, 221, 23), 100)
color_range3 = Rainbow::ColorRange.new(third_color, fouth_color, 50)

first_opacity  = Rainbow::Opacity.new(100, 0)
second_opacity = Rainbow::Opacity.new(100, 100)
opacity_range  = Rainbow::OpacityRange.new(first_opacity, second_opacity, 50)

filename = './example/output/gradient.png'
args = {
  reverse: false,
  opacity: 100,
  scale: 100,
  angle: 0,

  style: 'linear',
  gradient: {
    color_ranges: [color_range1, color_range2, color_range3],
    opacity_ranges: [opacity_range]
  }
}
gradient = Rainbow::Gradient.new(196, 28, args)
gradient.save_as_png(filename)

`open #{filename}`
