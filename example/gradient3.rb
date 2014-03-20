require './lib/rainbow'
require_relative 'gradient_factory'

filenames = GradientFactory.create_from_file('gradient3.yml')
`open #{filenames.join(' ')}`
