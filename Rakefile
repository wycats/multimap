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

task :default => :spec

require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.libs << "lib"
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ["-c", "-fs"]
end

begin
  gem 'rake-compiler'
  require 'rake/extensiontask'

  Rake::ExtensionTask.new do |ext|
    ext.name = 'nested_multimap_ext'
  end
rescue Gem::LoadError
end
