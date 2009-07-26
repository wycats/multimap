Gem::Specification.new do |s|
  s.name     = 'multimap'
  s.version  = '0.9.1'
  s.date     = '2009-05-26'
  s.summary  = 'Ruby implementation of multimap'
  s.description = <<-EOS
    Multimap includes a standard Ruby multimap implementation as well
    as a nested multimap and a fuzzy nested multimap
  EOS
  s.email    = 'josh@joshpeek.com'
  s.homepage = 'http://github.com/josh/multimap'
  s.rubyforge_project = 'multimap'
  s.has_rdoc = true
  s.authors  = ["Joshua Peek"]
  s.files    = [
    "ext/nested_multimap_ext.c",
    "lib/fuzzy_nested_multimap.rb",
    "lib/multimap.rb",
    "lib/multiset.rb",
    "lib/nested_multimap.rb"
  ]
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = %w[README.rdoc MIT-LICENSE]
  s.require_paths = %w[lib]
end
