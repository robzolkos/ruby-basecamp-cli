# frozen_string_literal: true

require_relative 'lib/basecamp/version'

Gem::Specification.new do |spec|
  spec.name          = 'basecamp-cli'
  spec.version       = Basecamp::VERSION
  spec.authors       = ['Rob Zolkos']
  spec.email         = ['rob@zolkos.com']

  spec.summary       = 'Command-line interface for Basecamp'
  spec.description   = 'A simple CLI for Basecamp. List projects, browse card tables, view cards, and move cards between columns.'
  spec.homepage      = 'https://github.com/robzolkos/ruby-basecamp-cli'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.0.0'

  spec.files         = Dir['lib/**/*', 'bin/*', 'README.md', 'LICENSE']
  spec.bindir        = 'bin'
  spec.executables   = ['basecamp']

  spec.add_dependency 'webrick', '~> 1.8'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
end
