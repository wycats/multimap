require 'nested_multimap'

class FuzzyNestedMultiMap < NestedMultiMap
  WILD_REGEXP = /.*/.freeze

  def []=(*args)
    case args.first
    when Regexp
      value = args.pop
      key   = args.shift || WILD_REGEXP
      keys  = args

      raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

      if keys.empty?
        each_pair_list { |k, l| l << value if key =~ k }
        append_to_default_container!(value)
      else
        self.keys.each { |k|
          if key =~ k
            update_container(k) do |container|
              container = self.class.new(container) if container.is_a?(default.class)
              container.store(keys, value)
              container
            end
          end
        }

        self.default = self.class.new(default) if default.is_a?(default.class)
        default[keys.dup] = value
      end
    when String
      super(*args)
    else
      raise ArgumentError, "unsupported key: #{args.first.inspect}"
    end
  end
end
