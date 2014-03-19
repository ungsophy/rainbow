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

        ranges.each { |range| break range if range.included?(x) }
      end
  end
end
