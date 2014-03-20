module Rainbow
  class OpacityRanges
    extend Forwardable

    attr_reader :ranges, :gradient, :current_x
    def_delegators :@current_range, :tmp_current_x, :tmp_from, :tmp_to, :tmp_diff, :tmp_distance_in_pixel

    def initialize(opacity_ranges, gradient)
      @ranges   = Array(opacity_ranges)
      @gradient = gradient
      @ranges.each { |range| range.gradient = gradient }
    end

    def current_x=(x)
      @current_range = get_range_by_x(x)
      @current_range.current_x = x
    end

    private

      def get_range_by_x(x)
        # since x is started at 0
        x += 1

        range = ranges.find { |range| range.included?(x) }
        return range if range

        first_range = ranges.first
        last_range  = ranges.last

        if first_range.from_opacity.location > 0 && first_range.from_location_in_pixel > x
          ranges.first
        elsif last_range.to_opacity.location < 100 && x > last_range.to_location_in_pixel
          ranges.last
        else
          raise "Cannot find current opacity range! .(#{first_range.from_location_in_pixel} - #{last_range.to_location_in_pixel}); (#{x})"
        end
      end
  end
end
