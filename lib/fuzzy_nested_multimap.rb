require 'nested_multimap'

class FuzzyNestedMultiMap < NestedMultiMap
  WILD_REGEXP = /.*/.freeze

  def []=(*args)
    keys  = args.dup
    value = keys.pop
    key   = keys.shift || WILD_REGEXP

    raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

    case key
    when Regexp
      if keys.empty?
        each_pair_list { |k, l| l << value if key =~ k }
        append_to_default_container!(value)
      else
        self.keys.each { |k|
          if key =~ k
            update_container(k) do |container|
              container = self.class.new(container) if container.is_a?(default.class)
              container[*keys] = value
              container
            end
          end
        }

        self.default = self.class.new(default) if default.is_a?(default.class)
        default[*keys.dup] = value
      end
    when String
      super(*args)
    else
      raise ArgumentError, "unsupported key: #{args.first.inspect}"
    end
  end
end
