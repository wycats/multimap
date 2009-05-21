require 'multimap'

require 'spec/enumerable_examples.rb'
require 'spec/hash_examples.rb'

shared_examples_for MultiMap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  it "should dup the collection container" do
    map2 = @map.dup
    map2.should_not equal(@map)
    map2.should == @map
    map2["a"].should_not equal(@map["a"])
    map2["b"].should_not equal(@map["b"])
  end

  it "should return an empty array if not key does not exist" do
    @map["z"].should == []
  end

  it "should have an empty hash for the default value" do
    @map.default.should == []
  end
end

describe MultiMap, "with inital values" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = MultiMap["a" => [100], "b" => [200, 300]]
  end
end

require 'set'

describe MultiMap, "with a Set collection" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = MultiMap.new(Set.new)
    @map["a"] = 100
    @map["b"] = 200
    @map["b"] = 300
  end

  it "should return an empty set if not key does not exist" do
    @map["c"].should == [].to_set
  end

  it "should return values as a Set" do
    @map["a"].should == [100].to_set
    @map["b"].should == [200, 300].to_set
  end
end
