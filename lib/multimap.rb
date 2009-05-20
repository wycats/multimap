class MultiMap < Hash
  def initialize
    super([])
  end

  def []=(key, value)
    values = self[key].dup
    values << value
    super(key, values)
  end
end
