require './lib/rainbow'

first_color  = Rainbow::Color.new(ChunkyPNG::Color(255, 0, 0), 0)
second_color = Rainbow::Color.new(ChunkyPNG::Color(0, 255, 0), 50)
third_color  = Rainbow::Color.new(ChunkyPNG::Color(0, 0, 255), 100)

color_range  = Rainbow::ColorRange.new(first_color, second_color, 50)
color_range2 = Rainbow::ColorRange.new(second_color, third_color, 50)


first_opacity  = Rainbow::Opacity.new(100, 0)
second_opacity = Rainbow::Opacity.new(100, 100)
opacity_range  = Rainbow::OpacityRange.new(first_opacity, second_opacity, 50)

filename = './example/output/gradient.png'
args = {
  reverse: false,
  opacity: 100,
  scale: 100,

  style: 'linear',
  gradient: {
    color_ranges: [color_range, color_range2],
    opacity_ranges: [opacity_range]
  }
}
gradient = Rainbow::Gradient.new(400, 50, args)
gradient.save_as_png(filename)

`open #{filename}`
