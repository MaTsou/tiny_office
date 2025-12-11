# A class extending Hash with a 'fine_merge' method which performs an 
# undestructive merge : only key => value with no Hash value are updated. No 
# subhashes override.
class ExtendedHash < Hash
  def fine_merge(hash)
    converted(hash).each do |(key, value)|
      case value
      when Hash, ExtendedHash
        self[key] = ExtendedHash[self.fetch(key, {})].
          fine_merge(ExtendedHash[value])
      when Array
        self[key] = self.fetch(key, []).union(value) # really !?
      else
        self[key] = value
      end
    end
    self
  end

  private

  def converted(hash)
    # using 'dup' here to avoid side effects.. Sufficient ?
    return hash.dup if hash.is_a? ExtendedHash

    ExtendedHash[hash]
  end
end
