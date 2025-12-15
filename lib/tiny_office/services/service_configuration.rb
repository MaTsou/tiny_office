module TinyOffice
  class ServiceConfiguration
    attr_reader :content

    def initialize
      @content = ExtendedHash.new
    end

    def add(**options)
      content.merge!(options)
    end

    def method_missing(name, *args)
      return super unless name[-1] == '='

      attr_name = name[..-2].to_sym
      add(attr_name => args.first) 
    end

    def fine_merge(hash)
      # Here, returning a new object and avoid side effects with duplicating 
      # content..
      self.class.new.tap do |sc|
        sc.add(**content.dup.fine_merge(hash))
      end
    end

    def ==(another)
      content == another.content
    end

    private

    class ExtendedHash < Hash
      def fine_merge(obj)
        converted(obj).each do |(key, value)|
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

      def converted(obj)
        case obj
        when ServiceConfiguration
          obj.content
        when Hash
          ExtendedHash[obj]
        when ExtendedHash
          obj
        else
          raise TypeError, "#{obj.class} has wrong type."
        end
      end
    end
  end
end
