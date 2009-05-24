require 'rubygems'

gem 'ruby-graphviz'
require 'graphviz'

class GraphViz
  ESCAPE = %w( \\ < > { } " " )
  ESCAPE_REGEXP = Regexp.compile("(#{Regexp.union(*ESCAPE).source})")

  def self.escape(str)
    str.to_str.gsub(ESCAPE_REGEXP) {|s| "\\#{s}" }
  end

  def self.to_node(obj)
    "node#{obj.object_id}"
  end

  def self.to_label(obj)
    case obj
    when Array
      "{#{obj.map { |e| to_label(e) }.join('|')}}"
    when Hash
      "#{obj.keys.map { |e|
        "<#{to_node(e)}> #{e.to_s}"
      }.join('|')}|<default>"
    else
      escape(obj.inspect)
    end
  end

  def add_object(obj, options = {})
    options.merge!(:label => self.class.to_label(obj))

    case obj
    when MultiMap
      hash_node = add_node(self.class.to_node(obj), options)

      obj.each_pair_list do |key, container|
        node = add_object(container)
        add_edge("#{hash_node.name}:#{self.class.to_node(key)}", node)
      end

      unless obj.default.nil?
        node = add_object(obj.default)
        add_edge("#{hash_node.name}:default", node)
      end

      hash_node
    else
      add_node(self.class.to_node(obj), options)
    end
  end
end

class MultiMap < Hash
  def to_graph
    g = GraphViz::new('G')
    g[:nodesep] = '.05'
    g[:rankdir] = 'LR'

    g.node[:shape] = 'record'
    g.node[:width] = '.1'
    g.node[:height] = '.1'

    g.add_object(self)

    g
  end

  def open_graph!
    to_graph.output(:path => '/opt/local/bin/', :file => '/tmp/graph.dot')
    system('open /tmp/graph.dot')
  end
end

if __FILE__ == $0
  $: << 'lib'
  require 'multimap'

  map = MultiMap['a' => 100, 'b' => [200, 300]]
  map.open_graph!
end
