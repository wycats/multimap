shared_examples_for Hash, MultiMap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  it "should be equal to another MultiMap if they contain the same keys and values" do
    @map.should == MultiMap["a" => [100], "b" => [200, 300]]
  end

  it "should not be equal to another MultiMap if they contain different values" do
    @map.should_not == MultiMap["a" => [100], "b" => [200]]
  end

  it "should retrieve collection of values for key" do
    @map["a"].should == [100]
    @map["b"].should == [200, 300]
    @map["z"].should == []
  end

  it "should append values to collection at key" do
    @map["a"] = 400
    @map.store("b", 500)
    @map["a"].should == [100, 400]
    @map["b"].should == [200, 300, 500]
  end

  it "should clear all key/values" do
    @map.clear
    @map.should be_empty
  end

  it "should return immutable default value" do
    @map.default.should == []
    @map.default.should be_frozen
  end

  it "should delete all values at key" do
    @map.delete("a")
    @map["a"].should == []
  end

  it "should delete single value at key" do
    @map.delete("b", 200)
    @map["b"].should == [300]
  end

  it "should delete if condition is matched" do
    @map.delete_if { |key, value| key >= "b" }.should == @map
    @map["a"].should == [100]
    @map["b"].should == []

    @map.delete_if { |key, value| key > "z" }.should == @map
  end

  it "should iterate over each key/value pair and yield an array" do
    a = []
    @map.each { |pair| a << pair }
    a.should == [["a", 100], ["b", 200], ["b", 300]]
  end

  it "should iterate over each key" do
    a = []
    @map.each_key { |key| a << key }
    a.should == ["a", "b"]
  end

  it "should iterate over each key/value pair and yield the pair" do
    h = {}
    @map.each_pair { |key, value| (h[key] ||= []) << value }
    h.should == { "a" => [100], "b" => [200, 300] }
  end

  it "should iterate over each value" do
    a = []
    @map.each_value { |value| a << value }
    a.should == [100, 200, 300]
  end

  it "should be empty if there are no key/value pairs" do
    @map.clear
    @map.should be_empty
  end

  it "should not be empty if there are any key/value pairs" do
    @map.should_not be_empty
  end

  it "should fetch collection of values for key" do
    @map.fetch("a").should == [100]
    @map.fetch("b").should == [200, 300]
    lambda { @map.fetch("z") }.should raise_error(IndexError)
  end

  it "should check if key is present" do
    @map.has_key?("a").should be_true
    @map.key?("a").should be_true
    @map.has_key?("z").should be_false
    @map.key?("z").should be_false
  end

  it "should check collections when looking up by value" do
    @map.has_value?(100).should be_true
    @map.value?(100).should be_true
    @map.has_value?(999).should be_false
    @map.value?(999).should be_false
  end

  it "it should return the index for value" do
    @map.index(200).should == ["b"]
    @map.index(999).should == []
  end

  it "should replace the contents of hash" do
    @map.replace({ "c" => [300], "d" => [400] })
    @map["a"].should == []
    @map["c"].should == [300]
  end

  it "should inspect contents" do
    @map.inspect.should == '{"a"=>[100], "b"=>[200, 300]}'
  end

  it "should return an inverted MultiMap" do
    @map.invert.should == MultiMap[100 => "a", 200 => "b", 300 => "b"]
  end

  it "should return array of keys" do
    @map.keys.should == ["a", "b"]
  end

  it "should return the number of key/value pairs" do
    @map.length.should == 3
    @map.size.should == 3
  end

  it "should duplicate map and with merged values" do
    map = @map.merge({ "b" => 254, "c" => 300 })
    map["a"].should == [100]
    map["b"].should == [200, 300, 254]
    map["c"].should == [300]

    @map["a"].should == [100]
    @map["b"].should == [200, 300]
    @map["c"].should == []
  end

  it "should update map" do
    @map.update("b" => 254, "c" => 300)
    @map["a"].should == [100]
    @map["b"].should == [200, 300, 254]
    @map["c"].should == [300]
  end

  it "should reject key/value pairs on copy of the map" do
    map = @map.reject { |key, value| key >= "b" }
    map["b"].should == []
    @map["b"].should == [200, 300]
  end

  it "should reject key/value pairs" do
    @map.reject! { |key, value| key >= "b" }.should == @map
    @map["a"].should == [100]
    @map["b"].should == []

    @map.reject! { |key, value| key >= "z" }.should == nil
  end

  it "should select key/value pairs" do
    @map.select { |k, v| k > "a" }.should == [["b", 200], ["b", 300]]
    @map.select { |k, v| v < 200 }.should == [["a", 100]]
  end

  it "should shift off key/value pair" do
    @map.shift.should == ["a", 100]
    @map["a"].should == []

    @map.shift.should == ["b", 200]
    @map["b"].should == [300]
  end

  it "should convert to array" do
    @map.to_a.should == [["a", [100]], ["b", [200, 300]]]
  end

  it "should convert to hash" do
    @map.to_hash.should == { "a" => [100], "b" => [200, 300] }
    @map.to_hash.should_not equal(@map)
  end

  it "should return all values" do
    @map.values.should == [100, 200, 300]
  end

  it "should return return values at keys" do
    @map.values_at("a", "b").should == [[100], [200, 300]]
  end
end