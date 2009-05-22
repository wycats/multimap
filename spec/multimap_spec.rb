require 'multimap'

require 'spec/enumerable_examples'
require 'spec/hash_examples'

describe MultiMap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = MultiMap["a" => 100, "b" => [200, 300]]
  end
end

describe MultiMap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = MultiMap["a", 100, "b", [200, 300]]
  end
end

require 'set'

describe MultiMap, "with", Set do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @container = Set
    @map = MultiMap.new(@container.new)
    @map["a"] = 100
    @map["b"] = 200
    @map["b"] = 300
  end
end


class MiniArray
  attr_accessor :data

  def initialize(data = [])
    @data = data
  end

  def <<(value)
    @data << value
  end

  def each(&block)
    @data.each(&block)
  end

  def delete(value)
    @data.delete(value)
  end

  def ==(other)
    case other
    when MiniArray
      @data == other.data
    when Array
      @data == other
    else
      false
    end
  end

  def to_ary
    @data.to_ary
  end

  def dup
    ary = super
    ary.data = @data.dup
    ary
  end
end

describe MultiMap, "with", MiniArray do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @container = MiniArray
    @map = MultiMap.new(@container.new)
    @map["a"] = 100
    @map["b"] = 200
    @map["b"] = 300
  end
end
