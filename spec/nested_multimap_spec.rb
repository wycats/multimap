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

  it "should append the value to default containers" do
    @map << 300
    @map.default.should == [300]
  end

  it "should append the value to all containers" do
    @map << 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300, 500]
    @map.default.should == [500]
  end

  it "default values should be copied to new containers" do
    @map << 300
    @map["x"] = 100
    @map["x"].should == [300, 100]
  end

  it "should list all containers" do
    @map.lists.should == [[100], [200, 300], []]
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

  it "should list all containers" do
    @map.lists.should == [[100], [200, 300], [200], [400, 500], [500], []]
  end
end
