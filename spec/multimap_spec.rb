require 'lib/multimap'

describe MultiMap do
  before do
    @map = MultiMap.new
  end

  it "should store key/value pairs" do
    @map[:foo] = "bar"
    @map[:foo].should eql(["bar"])
  end

  it "should store multiple values at a single key" do
    @map[:foo] = "bar"
    @map[:foo] = "baz"
    @map[:foo].should eql(["bar", "baz"])
  end
end

describe MultiMap, "with inital values" do
  before do
    @map = MultiMap["a" => 100, "b" => 200]
  end

  it "should be equal to another MultiMap if they contain the same keys and values" do
    @map.should == MultiMap["a" => 100, "b" => 200]
  end

  it "should fetch values at key" do
    @map["a"].should eql([100])
    @map["b"].should eql([200])
  end

  it "should return an empty array if not key does not exist" do
    @map["c"].should eql([])
  end

  it "should clear all key/values" do
    @map.clear
    @map.should be_empty
  end

  it "should have an empty hash for the default value" do
    @map.default.should eql([])
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
