module Rainbow
  class Gradient

    attr_reader :width, :height, :canvas, :ranges

    def initialize(colors, width, height)
      @width  = width
      @height = height
      @ranges = to_color_ranges(colors)
    end

    def generate
      @canvas    = ChunkyPNG::Canvas.new(width, height, ChunkyPNG::Color::TRANSPARENT)
      x_coverred = 0

      ranges.each_with_index do |range, index|
        range.x_coverred  = x_coverred

        range.distance_in_pixel.times do |x|
          range.current_x = x
          height.times { |y| @canvas[x_coverred + x, y] = range.current_color }
        end
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

          range = Rainbow::ColorRange.new(from_color, to_color, width)
          ranges << range

          ranges
        end
      end
  end
end
