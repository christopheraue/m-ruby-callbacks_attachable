require_relative 'mrblib/version'

MRuby::Gem::Specification.new('mruby-callbacks_attachable') do |spec|
  spec.version      = CallbacksAttachable::VERSION
  spec.summary      = %q{Attach callbacks to classes or individual instances.}
  spec.description  = <<-DESC
Attach callbacks to a class and trigger them for all its instances or just one
particular instance. Additionally, instances can also have their own set of
individual callbacks.
DESC
  spec.homepage     = "https://github.com/christopheraue/ruby-callbacks_attachable"
  spec.license      = 'MIT'
  spec.authors      = ['Christopher Aue']

  spec.add_dependency 'mruby-objectspace', :core => 'mruby-objectspace'
end
