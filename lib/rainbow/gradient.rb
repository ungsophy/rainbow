module Rainbow
  class Gradient

    attr_reader :width, :height, :canvas, :ranges

    def initialize(colors, width, height)
      @width  = width
      @height = height
      @ranges = to_color_ranges(colors)
    end

    def generate
      @canvas = ChunkyPNG::Canvas.new(width, height)
      x_coverred = 0

      ranges.each_with_index do |range, index|
        range.width             = width
        range.x_coverred        = x_coverred
        distance_in_pixel       = range.distance_in_pixel
        start_location_in_pixel = range.start_location_in_pixel

        # The start area
        if index == 0 && start_location_in_pixel > 0
          start_location_in_pixel.times do |x|
            height.times { |y| @canvas[x, y] = range.from_color.color }
          end
          x_coverred = start_location_in_pixel
        end

        distance_in_pixel.times do |x|
          range.current_x = x
          height.times { |y| @canvas[x_coverred + x, y] = range.current_color }
        end
        x_coverred += distance_in_pixel

        # The end area
        if ranges.size - 1 == index
          range.distance_to_go_in_pixel.times do |x|
            height.times { |y| @canvas[x_coverred + x, y] = range.to_color.color }
          end
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

          ranges << Rainbow::ColorRange.new(from_color, to_color)
          ranges
        end
      end
  end
end
