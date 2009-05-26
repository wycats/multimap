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

  it "should return true if the set is a superset of the given set" do
    set = Multiset[1, 2, 2, 3]

    set.superset?(Multiset[]).should be_true
    set.superset?(Multiset[1, 2]).should be_true
    set.superset?(Multiset[1, 2, 3]).should be_true
    set.superset?(Multiset[1, 2, 2, 3]).should be_true
    set.superset?(Multiset[1, 2, 2, 2]).should be_false
    set.superset?(Multiset[1, 2, 3, 4]).should be_false
    set.superset?(Multiset[1, 4]).should be_false
  end

  it "should return true if the set is a proper superset of the given set" do
    set = Multiset[1, 2, 2, 3, 3]

    set.proper_superset?(Multiset[]).should be_true
    set.proper_superset?(Multiset[1, 2]).should be_true
    set.proper_superset?(Multiset[1, 2, 3]).should be_true
    set.proper_superset?(Multiset[1, 2, 2, 3, 3]).should be_false
    set.proper_superset?(Multiset[1, 2, 2, 2]).should be_false
    set.proper_superset?(Multiset[1, 2, 3, 4]).should be_false
    set.proper_superset?(Multiset[1, 4]).should be_false
  end

  it "should return true if the set is a subset of the given set" do
    set = Multiset[1, 2, 2, 3]

    set.subset?(Multiset[1, 2, 2, 3, 4]).should be_true
    set.subset?(Multiset[1, 2, 2, 3, 3]).should be_true
    set.subset?(Multiset[1, 2, 2, 3]).should be_true
    set.subset?(Multiset[1, 2, 3]).should be_false
    set.subset?(Multiset[1, 2, 2]).should be_false
    set.subset?(Multiset[1, 2, 3]).should be_false
    set.subset?(Multiset[]).should be_false
  end

  it "should return true if the set is a proper subset of the given set" do
    set = Multiset[1, 2, 2, 3, 3]

    set.proper_subset?(Multiset[1, 2, 2, 3, 3, 4]).should be_true
    set.proper_subset?(Multiset[1, 2, 2, 3, 3]).should be_false
    set.proper_subset?(Multiset[1, 2, 3]).should be_false
    set.proper_subset?(Multiset[1, 2, 2]).should be_false
    set.proper_subset?(Multiset[1, 2, 3]).should be_false
    set.proper_subset?(Multiset[]).should be_false
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
