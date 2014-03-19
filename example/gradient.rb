require './lib/rainbow'

first_color  = Rainbow::Color.new(ChunkyPNG::Color(0, 0, 255), 0)
second_color = Rainbow::Color.new(ChunkyPNG::Color(255, 0, 0), 100)
# third_color  = Rainbow::Color.new(ChunkyPNG::Color(0, 255, 0), 100)

color_range1 = Rainbow::ColorRange.new(first_color, second_color, 50)
# color_range2 = Rainbow::ColorRange.new(second_color, third_color, 75)

first_opacity  = Rainbow::Opacity.new(70, 0)
second_opacity = Rainbow::Opacity.new(35, 100)
# third_opacity  = Rainbow::Opacity.new(30, 100)

opacity_range1 = Rainbow::OpacityRange.new(first_opacity, second_opacity, 50)
# opacity_range2 = Rainbow::OpacityRange.new(second_opacity, third_opacity, 80)

filename = './example/gradient.png'
gradient = Rainbow::Gradient.new(400, 50, [color_range1], [opacity_range1])
gradient.save_as_png(filename)
`open #{filename}`
