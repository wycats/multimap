require 'multimap'

require 'spec/enumerable_examples'
require 'spec/hash_examples'

describe MultiMap, "with inital values" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = MultiMap["a" => [100], "b" => [200, 300]]
  end
end

require 'set'

describe MultiMap, "with a", Set do
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
  instance_methods.each { |m| undef_method m unless m =~ /^__|^object_id$/ }

  def initialize(ary = [])
    @ary = ary
  end

  def <<(value)
    @ary << value
  end

  def each(&block)
    @ary.each(&block)
  end

  def ==(other)
    @ary == other
  end

  def respond_to?(sym)
    @ary.respond_to?(sym)
  end

  def freeze
    @ary.freeze
  end
end

describe MultiMap, "with ", MiniArray do
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
