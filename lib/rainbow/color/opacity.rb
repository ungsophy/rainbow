module Rainbow
  class Color
    class Opacity < Attribute
      def value
        @value * 255 / 100
      end
    end
  end
end
