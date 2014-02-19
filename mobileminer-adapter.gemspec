# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mobileminer/adapter/version'

Gem::Specification.new do |spec|
  spec.name          = 'mobileminer-adapter'
  spec.version       = Mobileminer::Adapter::VERSION
  spec.authors       = ['Nick Veys']
  spec.email         = ['nick@codelever.com']
  spec.description   = %q{Ruby gem to report miner information to MobileMiner.}
  spec.summary       = %q{MobileMiner reporting gem.}
  spec.homepage      = 'http://github.com/code-lever/mobileminer-adapter-gem.git'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'ci_reporter', '= 1.8.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2.13'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-gem-adapter'
  spec.add_development_dependency 'simplecov-rcov'

  spec.add_dependency 'awesome_print', '~> 1.2'
  spec.add_dependency 'cgminer-api', '~> 0.1'
  spec.add_dependency 'httparty', '~> 0.12'
end
