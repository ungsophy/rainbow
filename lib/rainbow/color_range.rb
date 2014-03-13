module Rainbow
  class ColorRange
    attr_reader :from_color, :to_color, :mid_point, :mid_color, :gradient_width
    attr_reader :distance_in_pixel, :first_half_distance, :second_half_distance
    attr_reader :start_location_in_pixel, :end_location_in_pixel
    attr_reader :tmp_current_x, :tmp_diff_r, :tmp_diff_g, :tmp_diff_b,
                :tmp_from_color, :tmp_to_color, :tmp_distance_in_pixel

    attr_accessor :x_coverred, :current_x

    def initialize(from_color, to_color, gradient_width)
      @from_color     = from_color
      @to_color       = to_color
      @gradient_width = gradient_width
      @mid_point      = from_color.location_mid_point.to_f

      @tmp_diff_r = nil
      @tmp_diff_g = nil
      @tmp_diff_b = nil
      @mid_color  = ChunkyPNG::Color(@from_color.r + (to_color.r - from_color.r) / 2,
                                     @from_color.g + (to_color.g - from_color.g) / 2,
                                     @from_color.b + (to_color.b - from_color.b) / 2)

      @x_coverred = nil # in pixel
      @current_x  = nil

      @distance_in_pixel     = @gradient_width * (to_color.location_value - from_color.location_value) / 100
      @first_half_distance   = @distance_in_pixel * @mid_point / 100
      @second_half_distance  = @distance_in_pixel - @first_half_distance

      @start_location_in_pixel = from_color.location_value * gradient_width / 100
      @end_location_in_pixel   = (100 - to_color.location_value) * gradient_width / 100
    end

    def current_x=(x)
      @current_x = x.to_f

      if x == 0
        @tmp_current_x         = 0.0
        @tmp_from_color        = from_color
        @tmp_to_color          = Rainbow::Color.new(mid_color, nil, nil)
        @tmp_distance_in_pixel = first_half_distance
        @tmp_diff_r            = @tmp_to_color.r - @tmp_from_color.r
        @tmp_diff_g            = @tmp_to_color.g - @tmp_from_color.g
        @tmp_diff_b            = @tmp_to_color.b - @tmp_from_color.b
      elsif x == first_half_distance
        @tmp_current_x         = 0.0
        @tmp_from_color        = Rainbow::Color.new(mid_color, nil, nil)
        @tmp_to_color          = to_color
        @tmp_distance_in_pixel = second_half_distance
        @tmp_diff_r            = @tmp_to_color.r - @tmp_from_color.r
        @tmp_diff_g            = @tmp_to_color.g - @tmp_from_color.g
        @tmp_diff_b            = @tmp_to_color.b - @tmp_from_color.b
      else
        @tmp_current_x += 1
      end
    end

    def current_color
      ChunkyPNG::Color(color(:r), color(:g), color(:b))
    end

    private

      def color(method)
        diff = __send__("tmp_diff_#{method}")
        (tmp_from_color.send(method) + (tmp_current_x / tmp_distance_in_pixel) * diff).to_i
      end
  end
end
