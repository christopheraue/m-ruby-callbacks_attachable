# coding: utf-8
require_relative 'mrblib/version'

Gem::Specification.new do |spec|
  spec.name          = "callbacks_attachable"
  spec.version       = CallbacksAttachable::VERSION
  spec.summary       = %q{Attach callbacks to classes or individual instances.}
  spec.description  = <<-DESC
Attach callbacks to a class and trigger them for all its instances or just one
particular instance. Additionally, instances can also have their own set of
individual callbacks.
  DESC

  spec.homepage      = "https://github.com/christopheraue/ruby-callbacks_attachable"
  spec.license       = "MIT"
  spec.authors       = ["Christopher Aue"]
  spec.email         = "rubygems@christopheraue.net"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
