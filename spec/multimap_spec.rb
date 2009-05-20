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
