Gem::Specification.new do |s|
  s.name     = 'multimap'
  s.version  = '1.0.0'
  s.date     = '2009-07-26'
  s.summary  = 'Ruby implementation of multimap'
  s.description = <<-EOS
    Multimap includes a Ruby multimap implementation
  EOS
  s.email    = 'josh@joshpeek.com'
  s.homepage = 'http://github.com/josh/multimap'
  s.rubyforge_project = 'multimap'
  s.has_rdoc = true
  s.authors  = ["Joshua Peek"]
  s.files    = [
    "ext/nested_multimap_ext.c",
    "lib/multimap.rb",
    "lib/multiset.rb",
    "lib/nested_multimap.rb"
  ]
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = %w[README.rdoc MIT-LICENSE]
  s.require_paths = %w[lib]
end
