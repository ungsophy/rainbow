module Rainbow
  class OpacityRange
    attr_reader :from_opacity, :to_opacity, :mid_point, :gradient
    attr_reader :tmp_current_x, :tmp_diff, :tmp_from, :tmp_to, :tmp_distance_in_pixel

    def initialize(from_opacity, to_opacity, mid_point)
      @from_opacity = from_opacity
      @to_opacity   = to_opacity
      @mid_point    = mid_point
    end

    def included?(x)
      @from_location_in_pixel <= x && x <= @to_location_in_pixel
    end

    def gradient=(gradient)
      @gradient = gradient
      compute_variables_in_pixel
    end

    def current_x=(x)
      if x == @from_location_in_pixel
        @tmp_current_x         = 0.0
        @tmp_diff              = mid_opacity - from_opacity.value
        @tmp_from              = from_opacity.value
        @tmp_to                = mid_opacity
        @tmp_distance_in_pixel = first_half_distance
      elsif x == @from_location_in_pixel + first_half_distance
        @tmp_current_x         = 0.0
        @tmp_diff              = to_opacity.value - mid_opacity
        @tmp_from              = mid_opacity
        @tmp_to                = to_opacity.value
        @tmp_distance_in_pixel = second_half_distance
      else
        @tmp_current_x += 1
      end
    end

    def mid_opacity
      from_opacity.value + (to_opacity.value - from_opacity.value) / 2
    end

    def first_half_distance
      mid_point * @distance_in_pixel / 100
    end

    def second_half_distance
      (100 - mid_point) * @distance_in_pixel / 100
    end

    private

      def compute_variables_in_pixel
        @from_location_in_pixel = from_opacity.location * gradient.width / 100
        @to_location_in_pixel   = to_opacity.location * gradient.width / 100
        @distance_in_pixel      = @to_location_in_pixel - @from_location_in_pixel
      end
  end
end
