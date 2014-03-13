module Rainbow
  class Color
    attr_reader :color, :location, :opacity

    # color    - Fixnum
    # location - Rainbow::Color::Location
    # opacity  - Rainbow::Color::Opacity
    def initialize(color, location, opacity)
      @color    = color
      @location = location
      @opacity  = opacity
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

    %w(location opacity).each do |attribute|
      define_method("#{attribute}_value")     { __send__(attribute).value }
      define_method("#{attribute}_mid_point") { __send__(attribute).mid_point }
    end
  end
end
