require 'lib/nested_multimap'

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
end

describe NestedMultiMap, "with inital values" do
  it_should_behave_like "Default MultiMap"
  it_should_behave_like "MultiMap with inital values {'a' => 100, 'b' => 200}"

  before do
    @map = NestedMultiMap["a" => 100, "b" => 200]
  end

  it "should append the value to all containers" do
    @map << 300
    @map["a"].should == [100, 300]
    @map["b"].should == [200, 300]
    @map.default.should == [300]
  end
end
