require_relative 'lib/all/version'

MRuby::Gem::Specification.new('mruby-callbacks_attachable') do |spec|
  spec.version      = CallbacksAttachable::VERSION
  spec.summary      = %q{Attach callbacks to classes or individual instances.}
  spec.description  = <<-DESC
Attach callbacks to classes to be triggered for all instances or attach them
to an individual instance to be triggered only for this instance.
DESC

  spec.homepage     = "https://github.com/christopheraue/m-ruby-callbacks_attachable"
  spec.license      = 'MIT'
  spec.authors      = ['Christopher Aue']

  spec.add_dependency 'mruby-objectspace', :core => 'mruby-objectspace'
  spec.add_dependency 'mruby-object-ext', :core => 'mruby-object-ext'

  spec.objs = Dir["#{spec.dir}/ext/mruby/**/*.c"].sort.map do |f|
    objfile(f.relative_path_from(spec.dir).to_s.pathmap("#{build_dir}/%X"))
  end
  spec.rbfiles =
    Dir["#{spec.dir}/lib/all/**/*.rb"].sort +
    Dir["#{spec.dir}/lib/mruby/**/*.rb"].sort
end
