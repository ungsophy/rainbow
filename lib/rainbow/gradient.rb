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

        # When the first color location is not 0
        if index == 0
          range.start_location_in_pixel.times do |x|
            height.times { |y| @canvas[x, y] = range.from_color.color }
          end
          x_coverred += range.start_location_in_pixel
        end

        range.distance_in_pixel.times do |x|
          range.current_x = x
          height.times { |y| @canvas[x + x_coverred, y] = range.current_color }
        end
        x_coverred += range.distance_in_pixel

        # When the last color location is not 100
        if index + 1 == ranges.size
          range.end_location_in_pixel.times do |x|
            height.times { |y| @canvas[x + x_coverred, y] = range.to_color.color }
          end
          x_coverred += range.end_location_in_pixel
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
