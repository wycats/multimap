class NestedMultiMap < MultiMap
  def initialize(default = [])
    map = super()
    map.default = default.freeze
    map
  end

  def store(*args)
    args.flatten!
    value = args.pop
    key   = args.shift
    keys  = args

    raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

    if keys.empty?
      super(key, value)
    else
      update_container(key) do |container|
        container = self.class.new(container) if container.is_a?(default.class)
        container.store(keys, value)
        container
      end
    end
  end
  alias_method :[]=, :store

  def <<(value)
    hash_values.each { |container| container.push(value) }
    self.default = default.dup.push(value)
    self.default.freeze
    nil
  end

  def [](*keys)
    keys.flatten!
    value = super(keys.shift)
    case value
    when self.class
      value[keys]
    when default.class
      value
    else
      raise RuntimeError
    end
  end
end
