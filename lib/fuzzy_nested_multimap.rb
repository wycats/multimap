require 'nested_multimap'

class FuzzyNestedMultiMap < NestedMultiMap
  WILD_REGEXP = /.*/.freeze

  def []=(*args)
    args.flatten!
    value = args.pop
    key   = args.shift
    key   = WILD_REGEXP if key.nil?
    keys  = args

    raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

    case key
    when Regexp
      if keys.empty?
        hash_each_pair { |k, v| v << value if key =~ k }
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
      super(key, keys, value)
    else
      raise ArgumentError, "unsupported key: #{key.inspect}"
    end
  end
end
