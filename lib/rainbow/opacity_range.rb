module Rainbow
  class OpacityRange
    attr_reader :from_opacity, :to_opacity, :mid_point, :gradient, :mid_opacity
    attr_reader :width, :first_width, :second_width, :leftover_width
    attr_reader :from_location_in_pixel, :mid_location_in_pixel, :to_location_in_pixel
    attr_reader :tmp_current_x, :tmp_diff, :tmp_from, :tmp_to, :tmp_distance_in_pixel
    attr_reader :scale_start_in_pixel, :scale_end_in_pixel, :scale_mid_in_pixel

    def initialize(from_opacity, to_opacity, mid_point)
      @from_opacity = from_opacity
      @to_opacity   = to_opacity
      @mid_point    = mid_point

      @mid_opacity  = from_opacity.value + (to_opacity.value - from_opacity.value) / 2
    end

    def included?(x)
      @from_location_in_pixel <= x && x <= @to_location_in_pixel
    end

    def gradient=(gradient)
      @gradient = gradient
      compute_variables
    end

    def current_x=(x)
      if x == 0 && from_opacity.location > 0
        @tmp_current_x         = 0.0
        @tmp_diff              = 0
        @tmp_from              = from_opacity.value
        @tmp_to                = from_opacity.value
        @tmp_distance_in_pixel = from_location_in_pixel
      elsif x == to_location_in_pixel && to_opacity.location < 100
        @tmp_current_x         = 0.0
        @tmp_diff              = 0
        @tmp_from              = to_opacity.value
        @tmp_to                = to_opacity.value
        @tmp_distance_in_pixel = leftover_width
      elsif x == from_location_in_pixel && gradient.scale_100?
        @tmp_current_x         = 0.0
        @tmp_diff              = mid_opacity - from_opacity.value
        @tmp_from              = from_opacity.value
        @tmp_to                = mid_opacity
        @tmp_distance_in_pixel = first_width
      elsif x == mid_location_in_pixel && gradient.scale_100?
        @tmp_current_x         = 0.0
        @tmp_diff              = to_opacity.value - mid_opacity
        @tmp_from              = mid_opacity
        @tmp_to                = to_opacity.value
        @tmp_distance_in_pixel = second_width
      elsif x == from_location_in_pixel && !gradient.scale_100?
        @tmp_current_x         = 0.0
        @tmp_diff              = 0
        @tmp_from              = from_opacity.value
        @tmp_to                = from_opacity.value
        @tmp_distance_in_pixel = 1
      elsif x == gradient.scale_start_location_in_pixel && !gradient.scale_100?
        @tmp_current_x         = 0.0
        @tmp_diff              = mid_opacity - from_opacity.value
        @tmp_from              = from_opacity.value
        @tmp_to                = from_opacity.value
        @tmp_distance_in_pixel = gradient.scale_half_distance_in_pixel
      elsif x == gradient.scale_mid_location_in_pixel && !gradient.scale_100?
        @tmp_current_x         = 0.0
        @tmp_diff              = to_opacity.value - mid_opacity
        @tmp_from              = mid_opacity
        @tmp_to                = to_opacity.value
        @tmp_distance_in_pixel = gradient.scale_half_distance_in_pixel
      else
        @tmp_current_x += 1
      end
    end

    private

      def compute_variables
        @width        = (to_opacity.location - from_opacity.location) * gradient.width / 100
        @first_width  = @width * mid_point / 100
        @second_width = @width - @first_width

        @from_location_in_pixel = from_opacity.location * gradient.width / 100
        @mid_location_in_pixel  = @from_location_in_pixel + @first_width
        @to_location_in_pixel   = @from_location_in_pixel + @width

        @leftover_width = (100 - to_opacity.location) * gradient.width / 100

        scale_start = (100 - gradient.scale) / 2
        scale_end   = scale_start == 0 ? 100 : scale_start + gradient.scale

        @scale_start_in_pixel = scale_start * gradient.width / 100
        @scale_end_in_pixel   = scale_end * gradient.width / 100
        @scale_mid_in_pixel   = @scale_start_in_pixel + (@scale_end_in_pixel - @scale_start_in_pixel) / 2
      end
  end
end
