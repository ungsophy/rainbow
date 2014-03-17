module Rainbow
  class Color
    class Location
      attr_reader :value, :mid_point

      def initialize(value, mid_point = 50)
        @value     = value
        @mid_point = mid_point

        assert_mid_point!
      end

      private

        def assert_mid_point!
          if mid_point < 5 || mid_point > 95
            raise ArgumentError, 'mid_point must be between 5 and 95'
          end
        end
    end
  end
end
