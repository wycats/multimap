require 'multimap'

class NestedMultiMap < MultiMap
  def store(*args)
    value = args.pop
    key   = args.shift
    keys  = args

    raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

    if keys.empty?
      super(key, value)
    else
      update_container(key) do |container|
        container = self.class.new(container) if container.is_a?(default.class)
        container[*keys] = value
        container
      end
    end
  end
  alias_method :[]=, :store

  def <<(value)
    each_pair_list { |key, container| container.push(value) }
    append_to_default_container!(value)
    nil
  end

  def [](*keys)
    result, i = self, 0
    until result.is_a?(default.class)
      result = result.hash_aref(keys[i])
      i += 1
    end
    result
  end

  private
    def append_to_default_container!(value)
      self.default = self.default.dup.push(value)
      self.default.freeze
    end
end

begin
  require 'nested_multimap_ext'

  class NestedMultiMap < MultiMap
    include NestedMultiMapExt
    alias_method :[], :native_aref
  end
rescue LoadError
end
