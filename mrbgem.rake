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

  spec.add_dependency 'mruby-object-ext', :core => 'mruby-object-ext'

  spec.objs = Dir["#{spec.dir}/ext/mruby/**/*.c"].sort.map do |f|
    objfile(f.relative_path_from(spec.dir).to_s.pathmap("#{build_dir}/%X"))
  end
  spec.rbfiles =
    Dir["#{spec.dir}/lib/all/**/*.rb"].sort +
    Dir["#{spec.dir}/lib/mruby/**/*.rb"].sort

  unless system("git merge-base --is-ancestor 5a9eedf5417266b82e3695ae0c29797182a5d04e HEAD")
    # mruby commit 5a9eedf fixed the usage of spec.rbfiles. mruby 1.3.0
    # did not have that commit, yet. Add the patch for this case:
    @generate_functions = true
    @objs << objfile("#{build_dir}/gem_init")
  end
end
