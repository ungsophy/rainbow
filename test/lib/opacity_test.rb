require './test/test_helper'

describe Rainbow::Opacity do
  describe 'when opacity is not between 0 and 100' do
    it 'raises ArgumentError' do
      -> { Rainbow::Opacity.new(101, 0) }.must_raise ArgumentError
      -> { Rainbow::Opacity.new(-1, 0) }.must_raise ArgumentError
    end
  end

  describe 'when location is not between 0 and 100' do
    it 'raises ArgumentError' do
      -> { Rainbow::Opacity.new(10, -1) }.must_raise ArgumentError
      -> { Rainbow::Opacity.new(10, 101) }.must_raise ArgumentError
    end
  end

  describe '#value' do
    it 'returns value' do
      opacity = Rainbow::Opacity.new(10, 50)
      opacity.value.must_equal 26
    end
  end
end
