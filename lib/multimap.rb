class MultiMap < Hash
  class << self
    alias_method :hash_s_create, :[]
    private :hash_s_create

    def [](*args)
      return _create([], *args)
    end

    def _create(default = [], *args)
      default.freeze

      if args.size == 1 && args.first.is_a?(Hash)
        args[0] = args.first.inject({}) { |hash, (key, value)|
          unless value.is_a?(default.class)
            value = (default.dup << value)
          end
          hash[key] = value
          hash
        }
      else
        index = 0
        args.map! { |value|
          unless index % 2 == 0 || value.is_a?(default.class)
            value = (default.dup << value)
          end
          index += 1
          value
        }
      end

      map = hash_s_create(*args)
      map.default = default
      map
    end
    protected :_create
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
      container
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

  def each
    each_pair do |key, value|
      yield [key, value]
    end
  end

  def each_key
    each_pair_list do |key, values|
      yield key
    end
  end

  alias_method :hash_each_pair, :each_pair
  protected :hash_each_pair

  alias_method :each_pair_list, :each_pair

  def each_pair
    each_pair_list do |key, values|
      values.each do |value|
        yield key, value
      end
    end
  end

  alias_method :hash_each_value, :each_value
  protected :hash_each_value

  def each_list
    hash_each_value do |value|
      yield value
    end
    yield default
    self
  end

  def each_value
    each_pair do |key, value|
      yield value
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
    when Array, Hash
      super(self.class.send(:_create, self.default, other))
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

  def keys
    keys = []
    each_key { |key| keys << key }
    keys
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

  def lists
    lists = []
    each_list { |container| lists << container }
    lists
  end

  def values
    values = []
    each_value { |value| values << value }
    values
  end

  protected
    def update_container(key)
      container = hash_aref(key)
      container = container.dup if container.equal?(default)
      container = yield(container)
      hash_aset(key, container)
    end
end
