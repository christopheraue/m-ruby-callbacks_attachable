# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'callbacks_attachable/version'

Gem::Specification.new do |spec|
  spec.name          = "callbacks_attachable"
  spec.version       = CallbacksAttachable::VERSION
  spec.authors       = ["Christopher Aue"]
  spec.email         = ["mail@christopheraue.net"]

  spec.summary       = %q{Attach callbacks to ruby objects. Then, trigger and detach them.}
  spec.homepage      = "https://github.com/christopheraue/ruby-callbacks_attachable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rspec-mocks-matchers-send_message", "~> 0.3"
end
