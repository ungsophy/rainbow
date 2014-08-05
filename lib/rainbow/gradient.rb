module Rainbow
  class Gradient

    attr_reader :width, :height, :args, :style, :color_ranges, :opacity_ranges
    attr_reader :canvas
    attr_reader :scale_start_location_in_pixel, :scale_mid_location_in_pixel,
                :scale_end_location_in_pixel, :scale_half_distance_in_pixel

    SUPPORTED_ANGLES = [0, 180]

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
      compute_scale_variables!
    end

    def create_canvas
      @canvas = ChunkyPNG::Canvas.new(width, height, ChunkyPNG::Color::TRANSPARENT)

      paint_canvas!(@canvas)
      set_opacity!(@canvas) if opacity != 100
      reverse!(@canvas) if reverse || angle == 180

      @canvas
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
      value = args.fetch(:angle, 0)
      value % 360
    end

    def scale
      args.fetch(:scale, 100)
    end

    def scale_100?
      scale == 100
    end

    def save_as_png(path)
      create_canvas unless canvas
      canvas.save(path, :fast_rgba)

      path
    end

    private

      def assert_arguments!
        _opacity_ranges = args[:gradient][:opacity_ranges]

        raise ArgumentError, 'args[:gradient][:color_ranges] cannot not be blank' if !color_ranges || color_ranges.size == 0
        raise ArgumentError, 'args[:gradient][:opacity_ranges] cannot not be blank' if !_opacity_ranges || _opacity_ranges.size == 0
        raise ArgumentError, 'args[:style] - Sorry, for now we support only linear gradient' if args[:style] != 'linear'
        raise ArgumentError, 'args[:scale] must be between 10 and 150' if scale < 10 || scale > 150
        raise ArgumentError, 'Sorry, we support only two colors stop if scale is not 100' if scale != 100 && color_ranges.size != 1
        raise ArgumentError, 'Sorry, we support only 0° or 180° angle' unless SUPPORTED_ANGLES.include?(angle)
      end

      def compute_scale_variables!
        scale_start = (100 - scale) / 2
        scale_end   = scale_start == 0 ? 100 : scale_start + scale

        @scale_start_location_in_pixel = scale_start * width / 100
        @scale_end_location_in_pixel   = scale_end * width / 100
        @scale_half_distance_in_pixel  = (@scale_end_location_in_pixel - @scale_start_location_in_pixel) / 2.0
        @scale_mid_location_in_pixel   = @scale_start_location_in_pixel + @scale_half_distance_in_pixel
      end

      def reverse!(canvas)
        canvas.flip_vertically!
      end

      def set_opacity!(canvas)
        width.times.each do |x|
          height.times.each do |y|
            color        = canvas[x, y]
            red          = ChunkyPNG::Color.r(color)
            green        = ChunkyPNG::Color.g(color)
            blue         = ChunkyPNG::Color.b(color)
            new_alpha    = ChunkyPNG::Color.a(color) * opacity / 100
            canvas[x, y] = ChunkyPNG::Color.rgba(red, green, blue, new_alpha)
          end
        end
      end

      def paint_canvas!(canvas)
        x_coverred           = 0
        previous_color_range = nil

        color_ranges.each_with_index do |color_range, index|
          color_range.previous       = previous_color_range
          color_range.gradient       = self
          color_range.opacity_ranges = opacity_ranges

          # When the first color location is not 0
          x_coverred += paint_prefix(canvas, color_range, x_coverred) if index == 0

          x_coverred += paint_body(canvas, color_range, x_coverred)

          # When the last color location is not 100
          x_coverred += paint_suffix(canvas, color_range, x_coverred) if index + 1 == color_ranges.size

          previous_color_range = color_range if index != 0
        end
      end

      def paint_prefix(canvas, color_range, x_coverred)
        color_range.from_location_in_pixel.times do |x|
          color_range.current_x = x
          height.times { |y| canvas[x, y] = color_range.current_color }
        end

        color_range.from_location_in_pixel
      end

      def paint_body(canvas, color_range, x_coverred)
        n = 0
        color_range.width.times do |x|
          if x == 0 && x + x_coverred != color_range.from_location_in_pixel
            n = x + x_coverred - color_range.from_location_in_pixel
          end

          x += x_coverred - n
          puts "  x: #{x}, n: #{n}" if ENV['RAINBOW_DEBUG']

          break if x == width

          color_range.current_x = x
          height.times { |y| canvas[x, y] = color_range.current_color }
        end

        color_range.width
      end

      def paint_suffix(canvas, color_range, x_coverred)
        color_range.leftover_width.times do |x|
          x += x_coverred

          break if x == width

          color_range.current_x = x
          height.times { |y| canvas[x, y] = color_range.current_color }
        end

        color_range.leftover_width
      end
  end
end
