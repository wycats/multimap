require 'spec'
require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.libs << "lib"
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ["-c", "-fs"]
end
