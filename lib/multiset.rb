require 'set'

class Multiset < Set
  attr_reader :hash
  protected :hash

  # def size
  #   @hash.size
  # end
  # alias length size

  # def replace(enum)
  #   if enum.class == self.class
  #     @hash.replace(enum.hash)
  #   else
  #     clear
  #     enum.each { |o| add(o) }
  #   end
  # 
  #   self
  # end

  # def to_a
  #   @hash.keys
  # end

  # def superset?(set)
  #   set.is_a?(Set) or raise ArgumentError, "value must be a set"
  #   return false if size < set.size
  #   set.all? { |o| include?(o) }
  # end

  # def proper_superset?(set)
  #   set.is_a?(Set) or raise ArgumentError, "value must be a set"
  #   return false if size <= set.size
  #   set.all? { |o| include?(o) }
  # end

  # def subset?(set)
  #   set.is_a?(Set) or raise ArgumentError, "value must be a set"
  #   return false if set.size < size
  #   all? { |o| set.include?(o) }
  # end

  # def proper_subset?(set)
  #   set.is_a?(Set) or raise ArgumentError, "value must be a set"
  #   return false if set.size <= size
  #   all? { |o| set.include?(o) }
  # end

  def each
    @hash.each_pair do |key, memberships|
      memberships.times do
        yield(key)
      end
    end
    self
  end

  def add(o)
    @hash[o] ||= 0
    @hash[o] += 1
    self
  end
  alias << add

  undef :add?

  # def delete(o)
  #   @hash.delete(o)
  #   self
  # end

  undef :delete?

  # def delete_if
  #   block_given? or return enum_for(__method__)
  #   to_a.each { |o| @hash.delete(o) if yield(o) }
  #   self
  # end

  # def merge(enum)
  #   if enum.instance_of?(self.class)
  #     @hash.update(enum.hash)
  #   else
  #     enum.each { |o| add(o) }
  #   end
  # 
  #   self
  # end

  # def subtract(enum)
  #   enum.each { |o| delete(o) }
  #   self
  # end

  # def |(enum)
  #   dup.merge(enum)
  # end
  # alias + |
  # alias union |

  # def -(enum)
  #   dup.subtract(enum)
  # end
  # alias difference

  # def &(enum)
  #   n = self.class.new
  #   enum.each { |o| n.add(o) if include?(o) }
  #   n
  # end
  # alias intersection &

  # def ^(enum)
  #   n = Set.new(enum)
  #   each { |o| if n.include?(o) then n.delete(o) else n.add(o) end }
  #   n
  # end

  # def ==(set)
  #   equal?(set) and return true
  # 
  #   set.is_a?(Set) && size == set.size or return false
  # 
  #   hash = @hash.dup
  #   set.all? { |o| hash.include?(o) }
  # end

  # def eql?(o)
  #   return false unless o.is_a?(self.class)
  #   @hash.eql?(o.hash)
  # end
end
