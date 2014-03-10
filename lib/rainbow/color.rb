module Rainbow
  class Color
    attr_reader :color, :location, :mid_point

    def initialize(color, location = nil, mid_point = 50)
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
        raise ArgumentError, 'mid_point must be between 0 and 100' if mid_point < 0 || mid_point > 100
      end
  end
end
