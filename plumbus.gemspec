# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plumbus/version'

Gem::Specification.new do |spec|
  spec.name          = "plumbus"
  spec.version       = Plumbus::VERSION
  spec.authors       = ["seo"]
  spec.email         = ["seotownsend@icloud.com"]

 
  spec.summary       = "Plubus is an agnostic micro-service router."
  spec.homepage      = "http://github.com/sotownsend/plumbus"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_runtime_dependency "activesupport", "~> 4.2"
  spec.add_runtime_dependency "msgpack", "~> 0.7"
end
