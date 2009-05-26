require 'nested_multimap'

class FuzzyNestedMultimap < NestedMultimap
  WILD_REGEXP = /.*/.freeze

  def []=(*args)
    keys  = args.dup
    value = keys.pop
    key   = keys.shift || WILD_REGEXP

    raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

    case key
    when Regexp
      if keys.empty?
        hash_each_pair { |k, l| l << value if key =~ k }
        append_to_default_container!(value)
      else
        hash_keys.each { |k|
          if key =~ k
            args[0] = k
            super(*args)
          end
        }

        self.default = self.class.new(default) unless default.is_a?(self.class)
        default[*keys.dup] = value
      end
    when String
      super(*args)
    else
      raise ArgumentError, "unsupported key: #{args.first.inspect}"
    end
  end
end
