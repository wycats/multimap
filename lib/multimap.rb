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

  def initialize(default = [])
    super(default.freeze)
  end

  alias_method :hash_aref, :[]
  alias_method :hash_aset, :[]=
  protected :hash_aref, :hash_aset

  def store(key, value)
    update_container(key) do |container|
      container << value
    end
  end
  alias_method :[]=, :store

  def dup
    map = super.clear
    each_pair { |key, value| map[key] = value }
    map
  end

  def delete(key, value = nil)
    if value
      hash_aref(key).delete(value)
    else
      super(key)
    end
  end

  alias_method :each_pair_list, :each_pair

  def each
    super do |key, values|
      values.each do |value|
        yield [key, value]
      end
    end
  end

  def each_pair
    super do |key, values|
      values.each do |value|
        yield key, value
      end
    end
  end

  def each_value
    super do |values|
      values.each do |value|
        yield value
      end
    end
  end

  def freeze
    each_pair_list { |key, container| container.freeze }
    super
  end

  def has_value?(value)
    values.include?(value)
  end
  alias_method :value?, :has_value?

  def index(value)
    invert[value]
  end

  def replace(other)
    case other
    when Hash
      default = self.default
      map = super(other.inject({}) { |h, (k, v)|
        container = default.dup
        if v.respond_to?(:each)
          v.each { |v| container << v }
        else
          container << v
        end
        h[k] = container
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
    h = MultiMap.new(default.dup)
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
    case other
    when Hash
      other.each_pair do |key, values|
        update_container(key) do |container|
          if values.respond_to?(:each)
            values.each { |value| container << value }
          else
            container << values
          end
          container
        end
      end
    else
      raise ArgumentError
    end

    self
  end
  alias_method :merge!, :update

  def select
    inject([]) { |result, pair|
      result << pair if yield(pair)
      result
    }
  end

  def to_a
    ary = []
    each_pair do |key, value|
      ary << [key, value]
    end
    ary
  end

  def to_hash
    dup
  end

  def values
    super.inject([]) { |values, container|
      values.push(*container)
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
