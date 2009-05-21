require 'fuzzy_nested_multimap'

require 'spec/enumerable_examples'
require 'spec/hash_examples'

shared_examples_for "Fuzzy", MultiMap do
  it "should add value to containers that match regexp key" do
    @map[/^a$/] = 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300]
    @map.default.should == [500]
  end
end

describe FuzzyNestedMultiMap, "with inital values" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Fuzzy MultiMap"

  before do
    @map = FuzzyNestedMultiMap["a" => [100], "b" => [200, 300]]
  end

  it "should append the value to all containers" do
    @map << 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300, 500]
    @map.default.should == [500]
  end

  it "should set value at nested key" do
    @map["foo", "bar", "baz"] = 100
    @map["foo", "bar", "baz"].should == [100]
  end

  it "should append the value to default containers" do
    @map << 300
    @map.default.should == [300]
  end

  it "should copy default values to new containers" do
    @map << 300
    @map["x"] = 100
    @map["x"].should == [300, 100]
  end
end
