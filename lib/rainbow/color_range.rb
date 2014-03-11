module Rainbow
  class ColorRange

    attr_reader :from_color, :to_color
    attr_accessor :width, :current_x, :x_coverred

    def initialize(from_color, to_color)
      @from_color = from_color
      @to_color   = to_color

      @width      = nil
      @current_x  = nil
      @x_coverred = nil # in pixel
    end

    def distance_in_percentage
      to_color.location - from_color.location
    end

    def start_location_in_pixel
      width * from_color.location / 100
    end

    def distance_to_go_in_pixel
      width * (100 - to_color.location) / 100
    end

    def distance_in_pixel
      raise ArgumentError, 'width is nil' unless width

      width * distance_in_percentage / 100
    end

    def current_color
      ChunkyPNG::Color(color(:r), color(:g), color(:b))
    end

    private

      def color(method)
        raise ArgumentError, 'current_x is nil' unless current_x

        span = distance_in_pixel
        t    = (current_x + 1).to_f

        (from_color.send(method) + (t / span) * (to_color.send(method) - from_color.send(method))).to_i
      end
  end
end
