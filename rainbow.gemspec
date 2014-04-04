# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rainbow/version'

Gem::Specification.new do |spec|
  spec.name          = 'rainbow_gradient'
  spec.version       = Rainbow::VERSION
  spec.authors       = ['Sophy Eung']
  spec.email         = ['ungsophy@gmail.com']
  spec.summary       = %q{A Ruby library to generate gradient.}
  spec.description   = %q{A Ruby library to generate gradient.}
  spec.homepage      = 'https://github.com/ungsophy/rainbow'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency             'chunky_png', '~> 1.3.0'

  spec.add_development_dependency 'bundler',    '~> 1.5'
  spec.add_development_dependency 'minitest',   '~> 5.3.0'
  spec.add_development_dependency 'rake'
end
