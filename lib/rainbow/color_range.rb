module Rainbow
  class ColorRange

    attr_reader :from_color, :to_color
    attr_accessor :width, :current_index

    def initialize(from_color, to_color)
      @from_color    = from_color
      @to_color      = to_color

      @width         = nil
      @current_index = nil
    end

    def distance
      to_color.location - from_color.location
    end

    def distance_in_pixel
      raise ArgumentError, 'width is nil' unless width

      width * distance / 100
    end

    def current_color
      ChunkyPNG::Color(color(:r), color(:g), color(:b))
    end

    private
      def color(method)
        raise ArgumentError, 'current_index is nil' unless current_index

        span = distance_in_pixel
        t    = (current_index + 1).to_f

        (from_color.send(method) + (t / span) * (to_color.send(method) - from_color.send(method))).to_i
      end
  end
end
