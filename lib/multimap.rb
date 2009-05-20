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

  def initialize(collection_klass = Array)
    super(collection_klass.new.freeze)
  end

  def store(key, value)
    values = self[key].dup
    values << value
    super(key, values)
  end
  alias_method :[]=, :store

  def each
    super do |key, values|
      values.each do |value|
        yield [key, value]
      end
    end
  end

  def each_pair(&block)
    super do |key, values|
      values.each do |value|
        yield key, value
      end
    end
  end

  def has_value?(value)
    values.include?(value)
  end

  def index(value)
    invert[value]
  end

  def invert
    h = {}
    each_pair { |key, value| h[value] = key }
    h
  end

  def values
    super.inject([]) { |values, collection|
      values.push(*collection)
      values
    }
  end
end
