require 'nested_multimap'

# FuzzyNestedMultimap is an extension on top of NestedMultimap
# that allows fuzzy matching.
class FuzzyNestedMultimap < NestedMultimap
  def self.[](*args) #:nodoc:
    map = super
    map.instance_variable_set('@fuzz', {})
    map
  end

  def initialize(default = []) #:nodoc:
    @fuzz = {}
    super
  end

  def initialize_copy(original) #:nodoc:
    @fuzz = original.instance_variable_get('@fuzz').dup
    super
  end

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
      @fuzz[value] = key
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

  def freeze #:nodoc:
    @fuzz.clear
    @fuzz = nil
    super
  end

  undef :index, :invert

  protected
    def update_container(key) #:nodoc:
      super do |container|
        if container.is_a?(self.class)
          container.each_container_with_default do |c|
            c.delete_if do |value|
              (requirement = @fuzz[value]) && key !~ requirement
            end
          end
        else
          container.delete_if do |value|
            (requirement = @fuzz[value]) && key !~ requirement
          end
        end
        yield container
      end
    end
end
