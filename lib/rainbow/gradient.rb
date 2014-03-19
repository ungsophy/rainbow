module Rainbow
  class Gradient

    attr_reader :width, :height, :color_ranges, :opacity_ranges
    attr_reader :canvas

    def initialize(width, height, color_ranges, opacity_ranges)
      @width          = width
      @height         = height
      @color_ranges   = Array(color_ranges)
      @opacity_ranges = OpacityRanges.new(opacity_ranges, self)
    end

    def generate
      @canvas    = ChunkyPNG::Canvas.new(width, height, ChunkyPNG::Color::TRANSPARENT)
      x_coverred = 0

      color_ranges.each_with_index do |color_range, index|
        color_range.gradient       = self
        color_range.opacity_ranges = opacity_ranges

        # When the first color location is not 0
        if index == 0
          color_range.start_location_in_pixel.times do |x|
            height.times { |y| @canvas[x, y] = color_range.from_color.color }
          end
          x_coverred += color_range.start_location_in_pixel
        end

        color_range.distance_in_pixel.times do |x|
          color_range.current_x = x
          height.times { |y| @canvas[x + x_coverred, y] = color_range.current_color }
        end
        x_coverred += color_range.distance_in_pixel

        # When the last color location is not 100
        if index + 1 == color_ranges.size
          color_range.end_location_in_pixel.times do |x|
            height.times { |y| @canvas[x + x_coverred, y] = color_range.to_color.color }
          end
          x_coverred += color_range.end_location_in_pixel
        end
      end
    end

    def save_as_png(path)
      generate unless canvas
      canvas.save(path, :fast_rgba)

      path
    end
  end
end
