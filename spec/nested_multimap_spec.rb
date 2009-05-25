require 'nested_multimap'

require 'spec/enumerable_examples'
require 'spec/hash_examples'

describe NestedMultiMap, "with inital values" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = NestedMultiMap["a" => [100], "b" => [200, 300]]
  end

  it "should set value at nested key" do
    @map["foo", "bar", "baz"] = 100
    @map["foo", "bar", "baz"].should == [100]
  end

  it "should allow nil keys to be set" do
    @map["b", nil] = 400
    @map["b", "c"] = 500

    @map["a"].should == [100]
    @map["b"].should == [200, 300]
    @map["b", nil].should == [200, 300, 400]
    @map["b", "c"].should == [200, 300, 500]
  end

  it "should append the value to default containers" do
    @map << 300
    @map[nil].should == [300]
  end

  it "should append the value to all containers" do
    @map << 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300, 500]
    @map[nil].should == [500]
  end

  it "default values should be copied to new containers" do
    @map << 300
    @map["x"] = 100
    @map["x"].should == [300, 100]
  end

  it "should list all containers" do
    @map.lists.should == [[100], [200, 300], []]
  end

  it "should list all values" do
    @map.values.should == [100, 200, 300]
  end
end

describe NestedMultiMap, "with nested values" do
  before do
    @map = NestedMultiMap.new
    @map["a"] = 100
    @map["b"] = 200
    @map["b", "c"] = 300
    @map["c", "e"] = 400
    @map["c"] = 500
  end

  it "should retrieve container of values for key" do
    @map["a"].should == [100]
    @map["b"].should == [200]
    @map["c"].should == [500]
    @map["a", "b"].should == [100]
    @map["b", "c"].should == [200, 300]
    @map["c", "e"].should == [400, 500]
  end

  it "should append the value to default containers" do
    @map << 600
    @map["a"].should == [100, 600]
    @map["b"].should == [200, 600]
    @map["c"].should == [500, 600]
    @map["a", "b"].should == [100, 600]
    @map["b", "c"].should == [200, 300, 600]
    @map["c", "e"].should == [400, 500, 600]
    @map[nil].should == [600]
  end

  it "should iterate over each key/value pair and yield an array" do
    a = []
    @map.each { |pair| a << pair }
    a.should == [
      ["a", 100],
      [["b", "c"], 200],
      [["b", "c"], 300],
      [["c", "e"], 400],
      [["c", "e"], 500]
    ]
  end

  it "should iterate over each key/container" do
    a = []
    @map.each_pair_list { |key, container| a << [key, container] }
    a.should == [
      ["a", [100]],
      [["b", "c"], [200, 300]],
      [["c", "e"], [400, 500]]
    ]
  end

  it "should iterate over each key" do
    a = []
    @map.each_key { |key| a << key }
    a.should == ["a", ["b", "c"], ["c", "e"]]
  end

  it "should iterate over each key/value pair and yield the pair" do
    h = {}
    @map.each_pair { |key, value| (h[key] ||= []) << value }
    h.should == {
      "a" => [100],
      ["c", "e"] => [400, 500],
      ["b", "c"] => [200, 300]
    }
  end

  it "should iterate over each container" do
    a = []
    @map.each_list { |container| a << container }
    a.should == [[100], [200, 300], [200], [400, 500], [500], []]
  end

  it "should iterate over each value" do
    a = []
    @map.each_value { |value| a << value }
    a.should == [100, 200, 300, 400, 500]
  end

  it "should list all containers" do
    @map.lists.should == [[100], [200, 300], [200], [400, 500], [500], []]
  end

  it "should return array of keys" do
    @map.keys.should == ["a", ["b", "c"], ["c", "e"]]
  end

  it "should list all values" do
    @map.values.should == [100, 200, 300, 400, 500]
  end
end


require 'set'

describe NestedMultiMap, "with", Set do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @container = Set
    @map = NestedMultiMap.new(@container.new)
    @map["a"] = 100
    @map["b"] = 200
    @map["b"] = 300
  end
end
