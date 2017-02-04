# coding: utf-8
require_relative 'mrblib/version'

Gem::Specification.new do |spec|
  spec.name          = "callbacks_attachable"
  spec.version       = CallbacksAttachable::VERSION
  spec.summary       = %q{Attach callbacks to classes or individual instances.}
  spec.description  = <<-DESC
Attach callbacks to classes to be triggered for all instances or attach them
to an individual instance to be triggered only for this instance.
  DESC

  spec.homepage      = "https://github.com/christopheraue/m-ruby-callbacks_attachable"
  spec.license       = "MIT"
  spec.authors       = ["Christopher Aue"]
  spec.email         = ["rubygems@christopheraue.net"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
