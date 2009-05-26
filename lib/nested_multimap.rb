require 'multimap'

class NestedMultimap < Multimap
  def store(*args)
    value = args.pop
    key   = args.shift
    keys  = args

    raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

    if keys.length > 0
      update_container(key) do |container|
        container = self.class.new(container) unless container.is_a?(self.class)
        container[*keys] = value
        container
      end
    else
      super(key, value)
    end
  end
  alias_method :[]=, :store

  def <<(value)
    hash_each_pair { |_, container| container << value }
    self.default << value
    nil
  end

  def [](*keys)
    i, l, r, k = 0, keys.length, self, self.class
    while r.is_a?(k)
      r = i < l ? r.hash_aref(keys[i]) : r.default
      i += 1
    end
    r
  end

  def each_pair_list
    super do |key, container|
      if container.respond_to?(:each_pair_list)
        container.each_pair_list do |nested_key, value|
          yield [key, nested_key].flatten, value
        end
      else
        yield key, container
      end
    end
  end

  def inspect
    super.gsub(/\}$/, ", nil => #{default.inspect}}")
  end
end

begin
  require 'nested_multimap_ext'
rescue LoadError
end
