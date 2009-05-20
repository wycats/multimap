require 'lib/nested_multimap'

describe NestedMultiMap, "with inital values" do
  it_should_behave_like "Default MultiMap"
  it_should_behave_like "MultiMap with inital values {'a' => 100, 'b' => 200}"

  before do
    @map = NestedMultiMap["a" => 100, "b" => 200]
  end
end
