require 'nested_multimap'

describe "Default", NestedMultiMap do
  it_should_behave_like "Default MultiMap"

  before do
    @map = NestedMultiMap.new
  end

  it "should set value at nested key" do
    @map["foo", "bar", "baz"] = 100
    @map["foo", "bar", "baz"].should == [100]
    @map.to_hash.should == { "foo" => { "bar" => { "baz" => [100] } } }
  end

  it "should append the value to default containers" do
    @map << 300
    @map.default.should == [300]
  end

  it "default values should be copied to new containers" do
    @map << 300
    @map["a"] = 100
    @map["a"].should == [300, 100]
  end
end

describe NestedMultiMap, "with inital values" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  it_should_behave_like "Default MultiMap"
  it_should_behave_like "MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = NestedMultiMap["a" => [100], "b" => [200, 300]]
  end

  it "should append the value to all containers" do
    @map << 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300, 500]
    @map.default.should == [500]
  end
end
