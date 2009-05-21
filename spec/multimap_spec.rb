require 'multimap'

shared_examples_for "Default", MultiMap do
  it "should store key/value pairs" do
    @map["foo"] = "bar"
    @map["foo"].should == ["bar"]
  end

  it "should store multiple values at a single key" do
    @map["foo"] = "bar"
    @map.store("foo", "baz")
    @map["foo"].should == ["bar", "baz"]
  end

  it "should return an empty array if not key does not exist" do
    @map["z"].should == []
  end

  it "should clear all key/values" do
    @map.clear
    @map.should be_empty
  end

  it "should have an empty hash for the default value" do
    @map.default.should == []
  end

  it "should replace the contents of the map" do
    @map.replace({ "c" => 300, "d" => 400 })
    @map["a"].should == []
    @map["c"].should == [300]
  end
end

shared_examples_for MultiMap, "with inital values {'a' => 100, 'b' => 200}" do
  it "should fetch values at key" do
    @map["a"].should == [100]
    @map["b"].should == [200]
  end

  it "should be equal to another MultiMap if they contain the same keys and values" do
    @map.should == MultiMap["a" => 100, "b" => 200]
  end

  it "should delete all values at key" do
    @map.delete("a")
    @map["a"].should == []
    @map["b"].should == [200]
  end

  it "should dup the collection container" do
    map2 = @map.dup
    map2.should_not equal(@map)
    map2.should == @map
    map2["a"].should_not equal(@map["a"])
    map2["b"].should_not equal(@map["b"])
  end

  it "should iterate over each key/value pair and yield an array" do
    a = []
    @map.each { |pair| a << pair }
    a.should == [["a", 100], ["b", 200]]
  end

  it "should iterate over each key/value pair and yield the pair" do
    h = {}
    @map.each_pair { |key, value| h[key] = value }
    h.should == { "a" => 100, "b" => 200}
  end

  it "should check collections when looking up by value" do
    @map.has_value?(100).should be_true
    @map.has_value?(999).should be_false
  end

  it "should check if key is present" do
    @map.has_key?("a").should be_true
    @map.has_key?("z").should be_false

    @map.include?("a").should be_true
    @map.include?("z").should be_false

    @map.key?("a").should be_true
    @map.key?("z").should be_false

    @map.member?("a").should be_true
    @map.member?("z").should be_false
  end

  it "it should return the key for value" do
    @map.index(200).should == ["b"]
    @map.index(999).should == []
  end

  it "should return an inverted hash" do
    @map.invert.should == MultiMap[100 => "a", 200 => "b"]
  end

  it "should return the number of key/value pairs" do
    @map.length.should == 2
  end

  it "should convert to array" do
    @map.to_a.should == [["a", [100]], ["b", [200]]]
  end

  it "should convert to hash" do
    @map.to_hash.should == { "a" => [100], "b" => [200] }
    @map.to_hash.should_not equal(@map)
  end

  it "should update multimap" do
    @map.update("c" => 300)
    @map["a"].should == [100]
    @map["b"].should == [200]
    @map["c"].should == [300]
  end

  it "should return all values" do
    @map.values.should == [100, 200]
  end

  it "should return return values at keys" do
    @map.values_at("a", "b").should == [[100], [200]]
  end
end

describe MultiMap, "with inital values" do
  it_should_behave_like "Default MultiMap"
  it_should_behave_like "MultiMap with inital values {'a' => 100, 'b' => 200}"

  before do
    @map = MultiMap["a" => 100, "b" => 200]
  end
end

require 'set'

describe MultiMap, "with a Set collection" do
  before do
    @map = MultiMap.new(Set)
    @map["a"] = 100
    @map["b"] = 200
  end

  it "should return an empty set if not key does not exist" do
    @map["c"].should == [].to_set
  end

  it "should return values as a Set" do
    @map["a"].should == [100].to_set
    @map["b"].should == [200].to_set
  end
end
