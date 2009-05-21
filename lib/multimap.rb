class MultiMap < Hash
  def self.[](*args)
    if args.first.is_a?(Hash)
      args[0] = args.first.inject({}) { |h, (k, v)|
        h[k] = v.is_a?(Array) ? v : [v]
        h
      }
    end

    map = super
    map.default = [].freeze
    map
  end

  def initialize(collection_klass = Array)
    super(collection_klass.new.freeze)
  end

  alias_method :hash_aref, :[]
  alias_method :hash_aset, :[]=
  private :hash_aref, :hash_aset

  def store(key, value)
    update_container(key) do |container|
      container << value
    end
  end
  alias_method :[]=, :store

  def dup
    map = self.class.new
    each_pair { |key, value| map.store(key, value) }
    map.default = default
    map
  end

  alias_method :each_pair_list, :each_pair

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

  def replace(other)
    case other
    when Hash
      default = self.default
      map = super(other.inject({}) { |h, (k, v)|
        h[k] = [v]
        h
      })
      map.default = default
      map
    when self.class
      super
    else
      raise ArgumentError
    end
  end

  def invert
    h = MultiMap.new
    each_pair { |key, value| h[value] = key }
    h
  end

  def size
    values.size
  end
  alias_method :length, :size

  def merge(other)
    dup.update(other)
  end

  def update(other)
    other.each_pair do |key, value|
      store(key, value)
    end
  end
  alias_method :merge!, :update

  def to_hash
    dup
  end

  def values
    super.inject([]) { |values, collection|
      values.push(*collection)
      values
    }
  end

  protected
    def update_container(key)
      container = hash_aref(key)
      container = container.dup if container.equal?(default)
      container = yield(container)
      hash_aset(key, container)
    end
end
