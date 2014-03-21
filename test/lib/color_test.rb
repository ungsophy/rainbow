require './test/test_helper'

describe Rainbow::Color do
  let(:red) { 112 }
  let(:green) { 95 }
  let(:blue) { 25 }
  let(:color_int) { ChunkyPNG::Color(red, green, blue) }
  let(:color) { Rainbow::Color.new(color_int, 90) }

  describe 'when location is not between 0 and 100' do
    it 'raises ArgumentError' do
      -> { Rainbow::Color.new(color_int, 110) }.must_raise ArgumentError
      -> { Rainbow::Color.new(color_int, 101) }.must_raise ArgumentError
      -> { Rainbow::Color.new(color_int, -1) }.must_raise ArgumentError
    end
  end

  describe '#r' do
    it 'returns red color code' do
      color.r.must_equal red
    end
  end

  describe '#g' do
    it 'returns green color code' do
      color.g.must_equal green
    end
  end

  describe '#b' do
    it 'returns blue color code' do
      color.b.must_equal blue
    end
  end
end
