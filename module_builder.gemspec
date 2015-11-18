# coding: utf-8

require File.expand_path("../lib/module_builder/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "module_builder"
  spec.version       = ModuleBuilder::VERSION.dup
  spec.authors       = ["Michael Herold"]
  spec.email         = ["michael.j.herold@gmail.com"]

  spec.summary       = "Dynamically build customized modules"
  spec.description   = "Dynamically build customized modules"
  spec.homepage      = "https://github.com/michaelherold/module_builder"
  spec.license       = "MIT"

  spec.files = %w(CHANGELOG.md LICENSE.md README.md Rakefile)
  spec.files += %w(module_builder.gemspec)
  spec.files += Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
end
