module Rainbow
  class Color
    attr_reader :color, :location

    # color     - Fixnum
    # location  - Fixnum (0-100)
    def initialize(color, location)
      @color    = color
      @location = location

      assert_location!
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

      def assert_location!
        raise ArgumentError, 'location must be between 0 and 100' if location < 0 || location > 100
      end
  end
end
