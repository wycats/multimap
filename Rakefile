require 'rake'
require 'rake/packagetask'
require 'rake/gempackagetask'

# load gemspec like github's gem builder to surface any SAFE issues.
Thread.new {
  require 'rubygems/specification'
  $spec = eval("$SAFE=3\n#{File.read('multimap.gemspec')}")
}.join
 
Rake::GemPackageTask.new($spec) do |package|
  package.gem_spec = $spec
end

desc 'Publish gem to RubyForge'
task :release => [ :package ] do
  group_id     = $spec.rubyforge_project
  package_id   = $spec.name
  release_name = $spec.version
  userfile     = File.expand_path("pkg/#{$spec.name}-#{$spec.version}.gem")

  sh "rubyforge add_release #{group_id} #{package_id} #{release_name} #{userfile}"
end

begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

Rake::RDocTask.new { |rdoc|
  rdoc.title    = 'Multimap'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.options << '--charset' << 'utf-8'

  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
}

task :default => :spec

require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.libs << "lib"
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ["-c", "-fs"]
end

Spec::Rake::SpecTask.new('spec:rcov') do |t|
  t.libs << "lib"
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end

begin
  gem 'rake-compiler'
  require 'rake/extensiontask'

  Rake::ExtensionTask.new do |ext|
    ext.name = 'nested_multimap_ext'
    ext.gem_spec = $spec
  end

  desc "Run specs using C ext"
  task "spec:ext" => [:compile, :spec, :clobber]
rescue Gem::LoadError
end
