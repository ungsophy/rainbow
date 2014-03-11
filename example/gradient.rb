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

colors << Rainbow::Color.new(ChunkyPNG::Color(0, 0, 255), 25)
colors << Rainbow::Color.new(ChunkyPNG::Color(255, 255, 255), 85)

filename = './example/gradient.png'
gradient = Rainbow::Gradient.new(colors, 400, 30)
gradient.save_as_png(filename)
`open #{filename}`
