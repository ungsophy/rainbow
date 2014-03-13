module Rainbow
  class Color
    attr_reader :color, :location, :mid_point

    # color     - Fixnum
    # location  - Fixnum (in percentage)
    # mid_point - Fixnum (in percentage)
    def initialize(color, location, mid_point = nil)
      @color     = color
      @location  = location
      @mid_point = mid_point

      assert_mid_point!
    end

    def r
      ChunkyPNG::Color.r(color)
    end

    def g
      ChunkyPNG::Color.g(color)
    end

    def b
      ChunkyPNG::Color.b(color)
    end

    private

      def assert_mid_point!
        if !mid_point.nil? && (mid_point < 5 || mid_point > 95)
          raise ArgumentError, 'mid_point must be between 5 and 95'
        end
      end
  end
end
