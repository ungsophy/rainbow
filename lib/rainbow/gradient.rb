module Rainbow
  class Gradient

    attr_reader :width, :height, :canvas, :ranges

    def initialize(colors, width, height)
      @width  = width
      @height = height
      @ranges = to_color_ranges(colors)
    end

    def generate
      @canvas           = ChunkyPNG::Canvas.new(width, height)
      distance_coverred = 0

      ranges.each do |range|
        range.width = width
        (span = range.distance_in_pixel).times do |x|
          range.current_index = x
          height.times { |y| @canvas[distance_coverred + x, y] = range.current_color }
        end

        distance_coverred += span
      end
    end

    def save_as_png(path)
      generate unless canvas
      canvas.save(path, :fast_rgba)

      path
    end

    private

      def to_color_ranges(colors)
        colors.each_with_index.inject([]) do |ranges, (from_color, index)|
          to_color = colors[index + 1]
          break ranges unless to_color

          ranges << Rainbow::ColorRange.new(from_color, to_color)
          ranges
        end
      end
  end
end
