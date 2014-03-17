require './lib/rainbow'

colors = []

color_int        = ChunkyPNG::Color(4, 4, 138)
color_location   = Rainbow::Color::ColorLocation.new(0)
opacity_location = Rainbow::Color::OpacityLocation.new(0)
colors << Rainbow::Color.new(color_int, 90, color_location, opacity_location)

color_int        = ChunkyPNG::Color(4, 4, 138)
color_location   = Rainbow::Color::ColorLocation.new(100)
opacity_location = Rainbow::Color::OpacityLocation.new(100)
colors << Rainbow::Color.new(color_int, 60, color_location, opacity_location)

filename = './example/gradient.png'
gradient = Rainbow::Gradient.new(colors, 400, 30)
gradient.save_as_png(filename)
`open #{filename}`
