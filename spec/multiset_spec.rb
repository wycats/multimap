require 'multiset'

require 'spec/set_examples'

describe Multiset do
  it_should_behave_like "Set"
end

describe Multiset, "with inital values" do
  it_should_behave_like "Set with inital values [1, 2]"

  before do
    @set = Multiset.new([1, 2])
  end
end
