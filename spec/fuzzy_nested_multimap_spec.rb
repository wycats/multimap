require 'fuzzy_nested_multimap'

require 'spec/enumerable_examples'
require 'spec/hash_examples'

shared_examples_for "Fuzzy", Multimap do
  it "should add value to containers that match regexp key" do
    @map[/^a$/] = 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300]
    @map[nil].should == [500]
  end

  it "should convert nil key to a Regexp" do
    @map[nil] = 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300, 500]
    @map[nil].should == [500]
  end

  it "should allow keys to be empty" do
    keys = []
    @map[*keys] = 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300, 500]
    @map[nil].should == [500]
  end

  it "should allow static keys nested below Regexp" do
    @map[nil, "c"] = 500
    @map["a"].should == [100]
    @map["a", "c"].should == [100, 500]
    @map["b"].should == [200, 300]
    @map["b", "c"].should == [200, 300, 500]
    @map[nil].should == []
    @map[nil, "c"].should == [500]
  end

  it "should work with another crazy situation" do
    @map[nil, "c"] = 400
    @map["b", "c"] = 500
    @map[nil, "c"] = 600

    @map["a"].should == [100]
    @map["a", "c"].should == [100, 400, 600]
    @map["b"].should == [200, 300]
    @map["b", "c"].should == [200, 300, 400, 500, 600]
    @map["c", "c"].should == [400, 600]
  end
end

describe FuzzyNestedMultimap, "with inital values" do
  it_should_behave_like "Enumerable Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Fuzzy Multimap"

  before do
    @map = FuzzyNestedMultimap["a" => [100], "b" => [200, 300]]
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
