module Rainbow
  class ColorRange
    attr_reader :from_color, :to_color, :mid_point, :gradient, :mid_color
    attr_reader :width, :first_width, :second_width
    attr_reader :from_location_in_pixel, :to_location_in_pixel, :mid_location_in_pixel, :leftover_width
    attr_reader :tmp_current_x, :tmp_diff_r, :tmp_diff_g, :tmp_diff_b, :tmp_from_color, :tmp_to_color, :tmp_distance_in_pixel

    attr_accessor :opacity_ranges

    def initialize(from_color, to_color, mid_point)
      @from_color = from_color
      @to_color   = to_color
      @mid_point  = mid_point
    end

    def gradient=(gradient)
      @gradient = gradient
      compute_variables
    end

    def current_x=(x)
      set_color_variables(x)
      set_opacity_variables(x)

      @tmp_opacity = compute_opacity(x)
    end

    def current_color
      ChunkyPNG::Color(color(:r), color(:g), color(:b), @tmp_opacity)
    end

    private

      def color(method)
        diff = __send__("tmp_diff_#{method}")
        (tmp_from_color.send(method) + (tmp_current_x / tmp_distance_in_pixel) * diff).to_i
      end

      def compute_opacity(x)
        ratio = @tmp_opacity_current_x / @tmp_opacity_distance_in_pixel
        (@tmp_opacity_from + ratio * @tmp_opacity_diff).round
      end

      def compute_variables
        @mid_color = ChunkyPNG::Color(from_color.r + (to_color.r - from_color.r) / 2,
                                      from_color.g + (to_color.g - from_color.g) / 2,
                                      from_color.b + (to_color.b - from_color.b) / 2)

        @width        = gradient.width * (to_color.location - from_color.location) / 100
        @first_width  = @width * mid_point / 100
        @second_width = @width - @first_width

        @from_location_in_pixel = from_color.location * gradient.width / 100
        @mid_location_in_pixel  = @from_location_in_pixel + @first_width
        @to_location_in_pixel   = @from_location_in_pixel + @width

        @leftover_width = (100 - to_color.location) * gradient.width / 100
      end

      def set_opacity_variables(x)
        opacity_ranges.current_x = x

        @tmp_opacity_current_x         = opacity_ranges.tmp_current_x
        @tmp_opacity_from              = opacity_ranges.tmp_from
        @tmp_opacity_to                = opacity_ranges.tmp_to
        @tmp_opacity_diff              = opacity_ranges.tmp_diff
        @tmp_opacity_distance_in_pixel = opacity_ranges.tmp_distance_in_pixel
      end

      def set_color_variables(x)
        if x == 0 && from_color.location > 0
          @tmp_current_x         = 0.0
          @tmp_from_color        = from_color
          @tmp_to_color          = from_color
          @tmp_distance_in_pixel = from_location_in_pixel
          @tmp_diff_r            = 0
          @tmp_diff_g            = 0
          @tmp_diff_b            = 0
        elsif x == from_location_in_pixel
          @tmp_current_x         = 0.0
          @tmp_from_color        = from_color
          @tmp_to_color          = Rainbow::Color.new(mid_color, 0)
          @tmp_distance_in_pixel = first_width
          @tmp_diff_r            = @tmp_to_color.r - @tmp_from_color.r
          @tmp_diff_g            = @tmp_to_color.g - @tmp_from_color.g
          @tmp_diff_b            = @tmp_to_color.b - @tmp_from_color.b
        elsif x == mid_location_in_pixel
          @tmp_current_x         = 0.0
          @tmp_from_color        = Rainbow::Color.new(mid_color, 0)
          @tmp_to_color          = to_color
          @tmp_distance_in_pixel = second_width
          @tmp_diff_r            = @tmp_to_color.r - @tmp_from_color.r
          @tmp_diff_g            = @tmp_to_color.g - @tmp_from_color.g
          @tmp_diff_b            = @tmp_to_color.b - @tmp_from_color.b
        elsif x == to_location_in_pixel && to_color.location < 100
          @tmp_current_x         = 0.0
          @tmp_from_color        = to_color
          @tmp_to_color          = to_color
          @tmp_distance_in_pixel = leftover_width
          @tmp_diff_r            = 0
          @tmp_diff_g            = 0
          @tmp_diff_b            = 0
        else
          @tmp_current_x += 1
        end
      end
  end
end
