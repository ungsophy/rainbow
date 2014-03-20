require './lib/rainbow'

first_color  = Rainbow::Color.new(ChunkyPNG::Color(0, 0, 255), 20)
second_color = Rainbow::Color.new(ChunkyPNG::Color(255, 0, 0), 50)
third_color  = Rainbow::Color.new(ChunkyPNG::Color(0, 255, 0), 100)
color_range1 = Rainbow::ColorRange.new(first_color, second_color, 50)
color_range2 = Rainbow::ColorRange.new(second_color, third_color, 50)

first_opacity  = Rainbow::Opacity.new(100, 10)
second_opacity = Rainbow::Opacity.new(40, 50)
third_opacity  = Rainbow::Opacity.new(100, 100)
opacity_range1 = Rainbow::OpacityRange.new(first_opacity, second_opacity, 50)
opacity_range2 = Rainbow::OpacityRange.new(second_opacity, third_opacity, 50)

filename = './example/output/gradient3.png'
gradient = Rainbow::Gradient.new(400, 50, [color_range1, color_range2], [opacity_range1, opacity_range2])
gradient.save_as_png(filename)
`open #{filename}`
