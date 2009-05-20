# TODO: Inheirt from NestedMultiMap
class FuzzyNestedMultiMap < Hash
  def initialize(default = [])
    super(default)
  end

  alias_method :at, :[]

  WILD_REGEXP = /.*/.freeze

  def []=(*args)
    args  = args.flatten
    value = args.pop
    key   = args.shift.freeze
    key   = WILD_REGEXP if key.nil?
    keys  = args.freeze

    raise ArgumentError, 'missing value' unless value

    case key
    when Regexp
      if keys.empty?
        each { |k, v| v << value if key =~ k }
        default << value
      else
        self.keys.each { |k|
          if key =~ k
            v = at(k)
            v = v.dup if v.equal?(default)
            v = NestedSet.new(v) if v.is_a?(Array)
            v[keys.dup] = value
            super(k, v)
          end
        }

        self.default = NestedSet.new(default) if default.is_a?(Array)
        default[keys.dup] = value
      end
    when String
      v = at(key)
      v = v.dup if v.equal?(default)

      if keys.empty?
        v << value
      else
        v = NestedSet.new(v) if v.is_a?(Array)
        v[keys.dup] = value
      end

      super(key, v)
    else
      raise ArgumentError, 'unsupported key'
    end
  end

  def dup
    set = self.class.new
    each { |k, v| set.store(k, v.dup) }
    set.default = default.dup
    set
  end

  def [](*keys)
    result, i = self, 0
    until result.is_a?(Array)
      result = result.at(keys[i])
      i += 1
    end
    result
  end

  def <<(value)
    values_with_default.each { |e| e << value }
    nil
  end

  def values_with_default
    values.push(default)
  end

  def inspect
    super.gsub(/\}$/, ", nil => #{default.inspect}}")
  end

  def freeze
    values_with_default.each { |v|
      v.each { |e| e.freeze } if v.is_a?(Array)
      v.freeze
    }
    super
  end
end
