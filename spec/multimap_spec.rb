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

describe MultiMap, "with a Set collection" do
  it_should_behave_like "Enumerable MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash MultiMap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @container = Set
    @map = MultiMap.new(@container.new)
    @map["a"] = 100
    @map["b"] = 200
    @map["b"] = 300
  end

  it "should return an empty set if not key does not exist" do
    @map["c"].should == [].to_set
  end

  it "should return containers as a Set" do
    @map["a"].should == [100].to_set
    @map["b"].should == [200, 300].to_set
  end
end
