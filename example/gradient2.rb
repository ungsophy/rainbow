require './lib/rainbow'

first_color  = Rainbow::Color.new(ChunkyPNG::Color(255, 0, 0), 30)
second_color = Rainbow::Color.new(ChunkyPNG::Color(0, 255, 0), 70)
color_range  = Rainbow::ColorRange.new(first_color, second_color, 50)

first_opacity  = Rainbow::Opacity.new(30, 10)
second_opacity = Rainbow::Opacity.new(100, 70)
opacity_range  = Rainbow::OpacityRange.new(first_opacity, second_opacity, 50)

filename = './example/gradient2.png'
gradient = Rainbow::Gradient.new(400, 50, color_range, opacity_range)
gradient.save_as_png(filename)
`open #{filename}`
