require 'multimap'

class NestedMultimap < Multimap
  def store(*args)
    value = args.pop
    key   = args.shift
    keys  = args

    raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

    if keys.length > 0
      update_container(key) do |container|
        container = self.class.new(container) if container.is_a?(default.class)
        container[*keys] = value
        container
      end
    else
      super(key, value)
    end
  end
  alias_method :[]=, :store

  def <<(value)
    hash_each_value { |container| container << value }
    append_to_default_container!(value)
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

  def each_list
    super do |container|
      if container.respond_to?(:each_list)
        container.each_list do |value|
          yield value
        end
      else
        yield container
      end
    end
  end

  def inspect
    super.gsub(/\}$/, ", nil => #{default.inspect}}")
  end

  private
    def append_to_default_container!(value)
      self.default = self.default.dup
      self.default << value
      self.default.freeze
    end
end

begin
  require 'nested_multimap_ext'
rescue LoadError
end
