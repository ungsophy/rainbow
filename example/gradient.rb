require './lib/rainbow'

first_color  = Rainbow::Color.new(ChunkyPNG::Color(79, 98, 255), 0)
second_color = Rainbow::Color.new(ChunkyPNG::Color(255, 0, 78), 100)
color_range  = Rainbow::ColorRange.new(first_color, second_color, 50)

first_opacity  = Rainbow::Opacity.new(100, 0)
second_opacity = Rainbow::Opacity.new(90, 100)
opacity_range  = Rainbow::OpacityRange.new(first_opacity, second_opacity, 50)

filename = './example/output/gradient.png'
args = {
  opacity: 80,
  style: 'linear',
  gradient: {
    color_ranges: [color_range],
    opacity_ranges: [opacity_range]
  }
}
gradient = Rainbow::Gradient.new(400, 50, args)
gradient.save_as_png(filename)
`open #{filename}`
