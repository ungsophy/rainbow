module Rainbow
  class Opacity

    attr_reader :value, :location

    # value    - Fixnum (0-100)
    # location - Fixnum (0-100)
    def initialize(value, location)
      @value_percentage = value
      @value            = (255.0 * value / 100).round
      @location         = location

      assert_arguments!
    end

    private

      def assert_arguments!
        raise ArgumentError, 'opacity must be between 0 and 100' if @value_percentage < 0 || @value_percentage > 100
        raise ArgumentError, 'location must be between 0 and 100' if location < 0 || location > 100
      end
  end
end
