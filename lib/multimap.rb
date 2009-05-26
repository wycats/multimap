require 'multiset'

class Multimap < Hash
  class << self
    alias_method :hash_s_create, :[]
    private :hash_s_create

    def [](*args)
      return _create([], *args)
    end

    def _create(default = [], *args) #:nodoc:
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

  # call-seq:
  #   map.delete(key, value)  => value
  #   map.delete(key)         => value
  #
  # Deletes and returns a key-value pair from <i>map</i>. If only
  # <i>key</i> is given, all the values matching that key will be
  # deleted.
  #
  #   map = Multimap["a" => 100, "b" => [200, 300]]
  #   map.delete("b", 300) #=> 300
  #   map.delete("a")      #=> [100]
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

  # call-seq:
  #   map.has_value?(value)    => true or false
  #   map.value?(value)        => true or false
  #
  # Returns <tt>true</tt> if the given value is present for any key
  # in <i>map</i>.
  #
  #   map = Multimap["a" => 100, "b" => [200, 300]]
  #   map.has_value?(300)   #=> true
  #   map.has_value?(999)   #=> false
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
    h = Multimap.new(default.dup)
    each_pair { |key, value| h[value] = key }
    h
  end

  alias_method :hash_keys, :keys
  protected :hash_keys

  # call-seq:
  #   map.keys    => multiset
  #
  # Returns a new +Multiset+ populated with the keys from this hash. See also
  # <tt>Multimap#values</tt>.
  #
  #   map = Multimap["a" => 100, "b" => [200, 300], "c" => 400]
  #   map.keys   #=> Multiset.new(["a", "b", "b", "c"])
  def keys
    keys = Multiset.new
    each_key { |key| keys << key }
    keys
  end

  # call-seq:
  #   map.length    =>  fixnum
  #   map.size      =>  fixnum
  #
  # Returns the number of key-value pairs in the map.
  #
  #   map = Multimap["a" => 100, "b" => [200, 300], "c" => 400]
  #   map.length        #=> 4
  #   map.delete("a")   #=> 100
  #   map.length        #=> 3
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
    inject(self.class.new) { |map, (key, value)|
      map[key] = value if yield([key, value])
      map
    }
  end

  # call-seq:
  #   map.to_a => array
  #
  # Converts <i>map</i> to a nested array of [<i>key,
  # value</i>] arrays.
  #
  #   map = Multimap["a" => 100, "b" => [200, 300], "c" => 400]
  #   map.to_a   #=> [["a", 100], ["b", 200], ["b", 300], ["c", 400]]
  def to_a
    ary = []
    each_pair do |key, value|
      ary << [key, value]
    end
    ary
  end

  # call-seq:
  #   map.to_hash => hash
  #
  # Converts <i>map</i> to a basic hash.
  #
  #   map = Multimap["a" => 100, "b" => [200, 300]]
  #   map.to_hash   #=> { "a" => [100], "b" => [200, 300] }
  def to_hash
    dup
  end

  def lists
    lists = []
    each_list { |container| lists << container }
    lists
  end

  # call-seq:
  #   map.values    => array
  #
  # Returns a new array populated with the values from <i>map</i>. See
  # also <tt>Multimap#keys</tt>.
  #
  #   map = Multimap["a" => 100, "b" => [200, 300]]
  #   map.values   #=> [100, 200, 300]
  def values
    values = []
    each_value { |value| values << value }
    values
  end

  protected
    def update_container(key) #:nodoc:
      container = hash_aref(key)
      container = container.dup if container.equal?(default)
      container = yield(container)
      hash_aset(key, container)
    end
end
