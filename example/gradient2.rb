require './lib/rainbow'
require_relative 'gradient_factory'

filenames = GradientFactory.create_from_file('gradient2.yml')
`open #{filenames.join(' ')}`
