module Rainbow
  class Gradient

    attr_reader :width, :height, :args, :style, :color_ranges, :opacity_ranges
    attr_reader :canvas

    # wdith  - The gradient width
    # height - The gradient height
    # args   - Hash that describes the property of the gradient
    #          {
    #            blend_mode: 'norm|diss|dark|...',
    #            dither: true|false,
    #            opacity: 0..100,
    #            gradient: {
    #              type: 'solid|noise',
    #              smoothness: 0..100,
    #              color_ranges: [],
    #              opacity_ranges: []
    #            },
    #            reverse: true|false,
    #            style: 'linear|radial|angle|reflected|diamond',
    #            align_with_layer: true|false,
    #            angle: 0..360,
    #            scale: 10..150
    #          }
    def initialize(width, height, args)
      @width  = width
      @height = height
      @args   = args

      @style          = args[:style]
      @color_ranges   = args[:gradient][:color_ranges]
      @opacity_ranges = OpacityRanges.new(args[:gradient][:opacity_ranges], self)

      assert_arguments!
    end

    def blend_mode
      args.fetch(:blend_mode, 'norm')
    end

    def dither
      args.fetch(:dither, false)
    end

    def opacity
      args.fetch(:opacity, 100)
    end

    def type
      args[:gradient][:type]
    end

    def smoothness
      args[:gradient][:smoothness]
    end

    def reverse
      args.fetch(:reverse, false)
    end

    def align_with_layer
      args.fetch(:align_with_layer, true)
    end

    def angle
      args.fetch(:angle, 0)
    end

    def scale
      args.fetch(:scale, 100)
    end

    def generate
      @canvas    = ChunkyPNG::Canvas.new(width, height, ChunkyPNG::Color::TRANSPARENT)
      x_coverred = 0

      color_ranges.each_with_index do |color_range, index|
        color_range.gradient       = self
        color_range.opacity_ranges = opacity_ranges

        # When the first color location is not 0
        x_coverred += paint_prefix(@canvas, color_range, x_coverred) if index == 0

        x_coverred += paint_body(@canvas, color_range, x_coverred)

        # When the last color location is not 100
        x_coverred += paint_suffix(@canvas, color_range, x_coverred) if index + 1 == color_ranges.size
      end
    end

    def save_as_png(path)
      generate unless canvas
      canvas.save(path, :fast_rgba)

      path
    end

    private

      def assert_arguments!
        _opacity_ranges = args[:gradient][:opacity_ranges]

        raise ArgumentError, 'args[:gradient][:color_ranges] cannot not be blank' if !color_ranges || color_ranges.size == 0
        raise ArgumentError, 'args[:gradient][:opacity_ranges] cannot not be blank' if !_opacity_ranges || _opacity_ranges.size == 0
        raise ArgumentError, 'args[:style] cannot not be blank' unless args[:style]
      end

      def paint_prefix(canvas, color_range, x_coverred)
        color_range.from_location_in_pixel.times do |x|
          color_range.current_x = x
          height.times { |y| canvas[x, y] = color_range.current_color }
        end

        color_range.from_location_in_pixel
      end

      def paint_body(canvas, color_range, x_coverred)
        color_range.width.times do |x|
          x += x_coverred
          color_range.current_x = x
          height.times { |y| canvas[x, y] = color_range.current_color }
        end

        color_range.width
      end

      def paint_suffix(canvas, color_range, x_coverred)
        color_range.leftover_width.times do |x|
          x += x_coverred
          color_range.current_x = x
          height.times { |y| canvas[x, y] = color_range.current_color }
        end

        color_range.leftover_width
      end
  end
end
