require 'fuzzy_nested_multimap'

require 'spec/enumerable_examples'
require 'spec/hash_examples'

shared_examples_for "Fuzzy", Multimap do
  it "should add value to containers that match regexp key" do
    @map[/^a$/] = 500
    @map["a"].should == [100, 500]
    @map["b"].should == [200, 300]
    @map[/.+/].should == [500]
  end

  it "should allow static keys nested below Regexp" do
    @map[/.+/, "c"] = 500
    @map["a"].should == [100]
    @map["a", "c"].should == [100, 500]
    @map["b"].should == [200, 300]
    @map["b", "c"].should == [200, 300, 500]
    @map[/.+/].should == []
    @map[/.+/, "c"].should == [500]
  end

  it "should work with another crazy situation" do
    @map[/.+/, "c"] = 400
    @map["b", "c"] = 500
    @map[/.+/, "c"] = 600

    @map["a"].should == [100]
    @map["a", "c"].should == [100, 400, 600]
    @map["b"].should == [200, 300]
    @map["b", "c"].should == [200, 300, 400, 500, 600]
    @map["c", "c"].should == [400, 600]
  end

  it "should not copy default values to new containers unless there key matches the new one" do
    @map = FuzzyNestedMultimap.new
    @map[/^b$/] = "b"
    @map["a"] = "a"
    @map["c"] = "c"

    @map["a"].should == ["a"]
    @map["b"].should == ["b"]
    @map["c"].should == ["c"]
  end

  it "should not copy default values to nested containers unless there key matches the new one" do
    @map = FuzzyNestedMultimap.new
    @map[/^[0-9]$/, "a", "c"] = "#ac"
    @map["b", "a", "c"] = "bac"
    @map["c"] = "c"

    @map["b", "a", "c"].should == ["bac"]
    @map["1", "a", "c"].should == ["#ac"]
    @map["2", "a", "c"].should == ["#ac"]
    @map["?", "a", "c"].should == ["#ac"]
    @map["c"].should == ["c"]
  end

  it "nested regexps are properly copied" do
    @map = FuzzyNestedMultimap.new
    @map[/.+/, /.+/, "z"] = "???z"
    @map["a"] = "a"
    @map["b"] = "b"

    @map["a"].should == ["a"]
    @map["b"].should == ["b"]
    @map["a", "b", "z"].should == ["???z", "a"]
    @map["x", "y", "z"].should == ["???z"]
  end

  it "does not lose deeply nested wild cards" do
    @map = FuzzyNestedMultimap.new
    @map["a"] = "a"
    @map[/.+/, /.+/, /.+/, "z"] = "???z"
    @map["b", "c"] = "bc"
    @map["a", /.+/, "b"] = "a?b"
    @map["a", /.+/, "c"] = "a?c"
    @map["c", "d"] = "cd"

    @map["a"].should == ["a"]
    @map["w", "x", "y", "z"].should == ["???z"]
    @map["b", "c"].should == ["bc"]
    @map["a", "a", "b"].should == ["a", "a?b"]
    @map["a", "b", "b"].should == ["a", "a?b"]
    @map["a", "a", "c"].should == ["a", "a?c"]
    @map["a", "b", "c"].should == ["a", "a?c"]
    @map["c", "d"].should == ["cd"]
  end

  it "should support any key that responds to =~" do
    @map[true] = "TrueClass"
    @map[false] = "FalseClass"
    @map[100] = "one hundred"
    @map[nil] = "null"

    @map[true].should == ["TrueClass"]
    @map[false].should == ["FalseClass"]
    @map[100].should == ["one hundred"]
    @map[nil].should == ["null"]
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

  it "should treat missing keys as append to all" do
    @map[] = 400
    @map["a"].should == [100, 400]
    @map["b"].should == [200, 300, 400]
    @map["c"].should == [400]
    @map[nil].should == [400]
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
