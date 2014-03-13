require './lib/rainbow'

colors = []

# colors << Rainbow::Color.new(ChunkyPNG::Color(12, 0, 255), 0)
# colors << Rainbow::Color.new(ChunkyPNG::Color(208, 0, 0), 35)
# colors << Rainbow::Color.new(ChunkyPNG::Color(36, 255, 0), 70)
# colors << Rainbow::Color.new(ChunkyPNG::Color(252, 255, 0), 100)

# colors << Rainbow::Color.new(ChunkyPNG::Color(0, 0, 255), 60)
# colors << Rainbow::Color.new(ChunkyPNG::Color(255, 255, 255), 100)

# colors << Rainbow::Color.new(ChunkyPNG::Color(0, 0, 255), 0)
# colors << Rainbow::Color.new(ChunkyPNG::Color(255, 255, 255), 60)

# colors << Rainbow::Color.new(ChunkyPNG::Color(0, 0, 255), 55)
# colors << Rainbow::Color.new(ChunkyPNG::Color(255, 255, 255), 75)

# colors << Rainbow::Color.new(ChunkyPNG::Color(255,   0,   0),  30, 80)
# colors << Rainbow::Color.new(ChunkyPNG::Color(255, 255, 255),  50, 10)
# colors << Rainbow::Color.new(ChunkyPNG::Color(  0,   0,   0),  70)

color_int = ChunkyPNG::Color(0, 0, 255)
location  = Rainbow::Color::Location.new(0, 50)
opacity   = Rainbow::Color::Opacity.new(100, 50)
colors << Rainbow::Color.new(color_int, location, opacity)

color_int = ChunkyPNG::Color(255, 0, 0)
location  = Rainbow::Color::Location.new(100, 50)
opacity   = Rainbow::Color::Opacity.new(100, 50)
colors << Rainbow::Color.new(color_int, location, opacity)

filename = './example/gradient.png'
gradient = Rainbow::Gradient.new(colors, 400, 30)
gradient.save_as_png(filename)
`open #{filename}`
