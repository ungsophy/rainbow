require 'yaml'
require 'pathname'

module GradientFactory
  extend self

  DATA_DIR   = Pathname('example/data')
  OUTPUT_DIR = Pathname('example/output')

  def create_from_file(filename)
    data = File.open(DATA_DIR.join(filename)) { |file| file.read }
    data = YAML.load(data)

    data.each_pair.inject([]) do |filenames, (filename, value)|
      color_ranges = value['color_ranges'].inject([]) do |ranges, data|
        h1, h2 = data['color1'], data['color2']
        color1 = Rainbow::Color.new(ChunkyPNG::Color(h1['red'], h1['green'], h1['blue']), h1['location'])
        color2 = Rainbow::Color.new(ChunkyPNG::Color(h2['red'], h2['green'], h2['blue']), h2['location'])
        ranges << Rainbow::ColorRange.new(color1, color2, data['mid_point'])
        ranges
      end

      opacity_ranges = value['opacity_ranges'].inject([]) do |ranges, data|
        h1, h2 = data['opacity1'], data['opacity2']
        opacity1 = Rainbow::Opacity.new(h1['value'], h1['location'])
        opacity2 = Rainbow::Opacity.new(h2['value'], h2['location'])
        ranges << Rainbow::OpacityRange.new(opacity1, opacity2, data['mid_point'])
      end

      args = {
        style: 'linear',
        gradient: {
          color_ranges: color_ranges,
          opacity_ranges: opacity_ranges
        }
      }

      gradient = Rainbow::Gradient.new(400, 50, args)
      filenames << gradient.save_as_png(OUTPUT_DIR.join("#{filename}.png"))
    end
  end
end
