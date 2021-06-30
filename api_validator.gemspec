# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "api_validator"
  spec.version       = ApiValidator::VERSION
  spec.authors       = ["sandipkaranjekar"]
  spec.email         = ["sandipkaranjekar@gmail.com"]

  spec.summary       = %q{RubyGem for API validation}
  spec.description   = %q{RubyGem for API validation. Here you need to set rules and messages in yml, rest of the things are handle by gem.}
  spec.homepage      = "https://github.com/sandipkaranjekar/api_validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "rake", "~> 12.3.3"
end
