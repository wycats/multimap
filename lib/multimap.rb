class MultiMap < Hash
  def self.[](*args)
    if args.first.is_a?(Hash)
      args[0] = args.first.inject({}) { |h, (k, v)|
        h[k] = [v]
        h
      }
    end

    map = super
    map.default = []
    map
  end

  def initialize
    super([])
  end

  def store(key, value)
    values = self[key].dup
    values << value
    super(key, values)
  end
  alias_method :[]=, :store
end
