require 'multiset'

require 'spec/set_examples'

describe Multiset do
  it_should_behave_like "Set"

  it "should return the multiplicity of the element" do
    set = Multiset.new([:a, :a, :b, :b, :b, :c])
    set.multiplicity(:a).should == 2
    set.multiplicity(:b).should == 3
    set.multiplicity(:c).should == 1
  end

  it "should return the cardinality of the set" do
    set = Multiset.new([:a, :a, :b, :b, :b, :c])
    set.cardinality.should == 6
  end

  it "should be eql" do
    s1 = Multiset.new([:a, :b])
    s2 = Multiset.new([:b, :a])
    s1.should eql(s2)

    s1 = Multiset.new([:a, :a])
    s2 = Multiset.new([:a])
    s1.should_not eql(s2)
  end

  it "should replace the contents of the set" do
    set = Multiset[:a, :b, :b, :c]
    ret = set.replace(Multiset[:a, :a, :b, :b, :b, :c])

    set.should equal(ret)
    set.should == Multiset[:a, :a, :b, :b, :b, :c]

    set = Multiset[:a, :b, :b, :c]
    ret = set.replace([:a, :a, :b, :b, :b, :c])

    set.should equal(ret)
    set.should == Multiset[:a, :a, :b, :b, :b, :c]
  end
end

describe Multiset, "with inital values" do
  it_should_behave_like "Set with inital values [1, 2]"

  before do
    @set = Multiset.new([1, 2])
  end

  it "should return the multiplicity of the element" do
    @set.multiplicity(1).should == 1
    @set.multiplicity(2).should == 1
  end

  it "should return the cardinality of the set" do
    @set.cardinality.should == 2
  end
end
