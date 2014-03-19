module Rainbow
  class ColorRange
    attr_reader :from_color, :to_color, :mid_point, :gradient, :mid_color
    attr_reader :distance_in_pixel, :color_first_half_distance, :color_second_half_distance
    attr_reader :start_location_in_pixel, :end_location_in_pixel
    attr_reader :tmp_current_x, :tmp_diff_r, :tmp_diff_g, :tmp_diff_b,
                :tmp_from_color, :tmp_to_color, :tmp_distance_in_pixel

    attr_accessor :opacity_ranges

    def initialize(from_color, to_color, mid_point)
      @from_color = from_color
      @to_color   = to_color
      @mid_point  = mid_point
    end

    def gradient=(gradient)
      @gradient = gradient
      init_variables
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

      def init_variables
        @mid_color = ChunkyPNG::Color(from_color.r + (to_color.r - from_color.r) / 2,
                                      from_color.g + (to_color.g - from_color.g) / 2,
                                      from_color.b + (to_color.b - from_color.b) / 2)

        @distance_in_pixel = gradient.width * (to_color.location - from_color.location) / 100

        @color_first_half_distance = @distance_in_pixel * mid_point / 100
        @color_second_half_distance = @distance_in_pixel - @color_first_half_distance

        @start_location_in_pixel = from_color.location * gradient.width / 100
        @end_location_in_pixel = (100 - to_color.location) * gradient.width / 100
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
        if x == 0
          @tmp_current_x         = 0.0
          @tmp_from_color        = from_color
          @tmp_to_color          = Rainbow::Color.new(mid_color, 0)
          @tmp_distance_in_pixel = color_first_half_distance
          @tmp_diff_r            = @tmp_to_color.r - @tmp_from_color.r
          @tmp_diff_g            = @tmp_to_color.g - @tmp_from_color.g
          @tmp_diff_b            = @tmp_to_color.b - @tmp_from_color.b
        elsif x == color_first_half_distance
          @tmp_current_x         = 0.0
          @tmp_from_color        = Rainbow::Color.new(mid_color, 0)
          @tmp_to_color          = to_color
          @tmp_distance_in_pixel = color_second_half_distance
          @tmp_diff_r            = @tmp_to_color.r - @tmp_from_color.r
          @tmp_diff_g            = @tmp_to_color.g - @tmp_from_color.g
          @tmp_diff_b            = @tmp_to_color.b - @tmp_from_color.b
        else
          @tmp_current_x += 1
        end
      end
  end
end
