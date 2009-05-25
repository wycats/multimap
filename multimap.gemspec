Gem::Specification.new do |s|
  s.name     = 'multimap'
  s.version  = '0.0.1'
  s.date     = '2009-05-20'
  s.summary  = 'Ruby implementation of multimap'
  s.description = <<-EOS
    Multimap includes a standard Ruby multimap implementation as well
    as a nested multimap and a fuzzy nested multimap
  EOS
  s.email    = 'josh@joshpeek.com'
  s.homepage = 'http://github.com/josh/multimap'
  s.rubyforge_project = 'multimap'
  s.has_rdoc = false
  s.authors  = ["Joshua Peek", "Joshua Hull"]
  s.files    = [
    "lib/fuzzy_nested_multimap.rb",
    "lib/multimap.rb",
    "lib/multiset.rb",
    "lib/nested_multimap.rb"
  ]
  s.extra_rdoc_files = %w[README.rdoc MIT-LICENSE]
  s.require_paths = %w[lib]
end
