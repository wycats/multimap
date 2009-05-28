require 'nested_multimap'

# FuzzyNestedMultimap is an extension on top of NestedMultimap
# that allows fuzzy matching.
class FuzzyNestedMultimap < NestedMultimap
  # call-seq:
  #   multimap[*keys] = value      => value
  #   multimap.store(*keys, value) => value
  #
  # Associates the value given by <i>value</i> with multiple key
  # given by <i>keys</i>. Valid keys are restricted to strings
  # and regexps. If a Regexp is used as a key, the value will be
  # insert at every String key that matches that expression.
  def store(*args)
    keys  = args.dup
    value = keys.pop
    key   = keys.shift

    raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

    unless key.respond_to?(:=~)
      raise ArgumentError, "unsupported key: #{args.first.inspect}"
    end

    if key.is_a?(Regexp)
      if keys.empty?
        hash_each_pair { |k, l| l << value if k =~ key }
        self.default << value
      else
        hash_each_pair { |k, _|
          if k =~ key
            args[0] = k
            super(*args)
          end
        }

        self.default = self.class.new(default) unless default.is_a?(self.class)
        default[*keys.dup] = value
      end
    else
      super(*args)
    end
  end
  alias_method :[]=, :store

  undef :index, :invert
end
