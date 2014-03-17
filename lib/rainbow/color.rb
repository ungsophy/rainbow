module Rainbow
  class Color
    attr_reader   :color, :color_location, :opacity_location
    attr_accessor :opacity

    # color    - Fixnum
    # opacity  - Fixnum (0-100)
    # location - Rainbow::Color::ColorLocation
    # opacity  - Rainbow::Color::OpacityLocation
    def initialize(color, opacity, color_location, opacity_location)
      @color            = color
      @opacity          = opacity
      @color_location   = color_location
      @opacity_location = opacity_location
    end

    def opacity
      @opacity.to_f * 255 / 100
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

    %w(color opacity).each do |attribute|
      define_method("#{attribute}_location_value") { __send__("#{attribute}_location").value }
      define_method("#{attribute}_mid_point")      { __send__("#{attribute}_location").mid_point }
    end
  end
end
