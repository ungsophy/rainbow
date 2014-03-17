module Rainbow
  class ColorRange
    attr_reader :from_color, :to_color, :mid_color
    attr_reader :distance_in_pixel, :color_first_half_distance, :color_second_half_distance
    attr_reader :start_location_in_pixel, :end_location_in_pixel
    attr_reader :tmp_current_x, :tmp_diff_r, :tmp_diff_g, :tmp_diff_b,
                :tmp_from_color, :tmp_to_color, :tmp_distance_in_pixel

    def initialize(from_color, to_color, gradient_width)
      @from_color = from_color
      @to_color   = to_color

      reset_color_opacity!
      init_variables(gradient_width)
    end

    def current_x=(x)
      set_color_variables(x)
      set_opacity_variables(x)

      ratio        = @tmp_opacity_current_x / @tmp_opacity_distance_in_pixel
      @tmp_opacity = (@tmp_opacity_from + ratio * @tmp_opacity_diff).round
    end

    def current_color
      ChunkyPNG::Color(color(:r), color(:g), color(:b), @tmp_opacity)
    end

    private

      def color(method)
        diff = __send__("tmp_diff_#{method}")
        (tmp_from_color.send(method) + (tmp_current_x / tmp_distance_in_pixel) * diff).to_i
      end

      def reset_color_opacity!
        from_color_opacity = from_color.instance_variable_get(:@opacity)
        to_color_opacity   = to_color.instance_variable_get(:@opacity)

        from_color.opacity = from_color_opacity - (from_color_opacity * 0.1) + (to_color_opacity * 0.1)
        to_color.opacity   = to_color_opacity   - (to_color_opacity * 0.1)   + (from_color_opacity * 0.1)
      end

      def set_opacity_variables(x)
        if x == 0
          @tmp_opacity_current_x         = 0.0
          @tmp_opacity_diff              = @mid_opacity - from_color.opacity
          @tmp_opacity_from              = from_color.opacity
          @tmp_opacity_to                = @mid_opacity
          @tmp_opacity_distance_in_pixel = @opacity_first_half_distance
        elsif x == @opacity_first_half_distance
          @tmp_opacity_current_x         = 0.0
          @tmp_opacity_from              = @mid_opacity
          @tmp_opacity_to                = to_color.opacity
          @tmp_opacity_diff              = to_color.opacity - @mid_opacity
          @tmp_opacity_distance_in_pixel = @opacity_second_half_distance
        else
          @tmp_opacity_current_x += 1
        end
      end

      def set_color_variables(x)
        if x == 0
          @tmp_current_x         = 0.0
          @tmp_from_color        = from_color
          @tmp_to_color          = Rainbow::Color.new(mid_color, nil, nil, nil)
          @tmp_distance_in_pixel = color_first_half_distance
          @tmp_diff_r            = @tmp_to_color.r - @tmp_from_color.r
          @tmp_diff_g            = @tmp_to_color.g - @tmp_from_color.g
          @tmp_diff_b            = @tmp_to_color.b - @tmp_from_color.b
        elsif x == color_first_half_distance
          @tmp_current_x         = 0.0
          @tmp_from_color        = Rainbow::Color.new(mid_color, nil, nil, nil)
          @tmp_to_color          = to_color
          @tmp_distance_in_pixel = color_second_half_distance
          @tmp_diff_r            = @tmp_to_color.r - @tmp_from_color.r
          @tmp_diff_g            = @tmp_to_color.g - @tmp_from_color.g
          @tmp_diff_b            = @tmp_to_color.b - @tmp_from_color.b
        else
          @tmp_current_x += 1
        end
      end

      def init_variables(gradient_width)
        @mid_color  = ChunkyPNG::Color(from_color.r + (to_color.r - from_color.r) / 2,
                                       from_color.g + (to_color.g - from_color.g) / 2,
                                       from_color.b + (to_color.b - from_color.b) / 2)
        @mid_opacity = from_color.opacity + (to_color.opacity - from_color.opacity) / 2

        @distance_in_pixel = gradient_width * (to_color.color_location_value - from_color.color_location_value) / 100

        @color_first_half_distance  = @distance_in_pixel * from_color.color_mid_point / 100
        @color_second_half_distance = @distance_in_pixel - @color_first_half_distance

        @opacity_first_half_distance  = @distance_in_pixel * from_color.opacity_mid_point / 100
        @opacity_second_half_distance = @distance_in_pixel - @opacity_first_half_distance

        @start_location_in_pixel = from_color.color_location_value * gradient_width / 100
        @end_location_in_pixel   = (100 - to_color.color_location_value) * gradient_width / 100
      end
  end
end
