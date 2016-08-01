module Akin
  # A thread safe cache class, protected by a mutex
  class Cache # Create a new thread safe cache.
    def initialize(options = false)
      @mutex = Mutex.new if RUBY_ENGINE != 'opal'
      @hash  = options || {}
      @hash.each { |k, v| @hash[k] = Cache.new(v) if v.is_a?(Hash) }
      @hash
    end

    # Make getting value from underlying hash thread safe.
    def [](key)
      if RUBY_ENGINE == 'opal'
        @hash[key]
      else
        @mutex.synchronize { @hash[key] }
      end
    end
    alias get []

    # Make setting value in underlying hash thread safe.
    def []=(key, value)
      if RUBY_ENGINE == 'opal'
        @hash[key] = value
      else
        @mutex.synchronize { @hash[key] = value }
      end
    end
    alias set []=

      def to_json
        @mutex.synchronize do
          json_hash = {}

          @hash.each do |k, v|
            json_hash[k] = v.kind_of?(Cache) ? v.hash : v
          end

          json_hash.to_json
        end
      end

    def hash
      if RUBY_ENGINE == 'opal'
        @hash
      else
        @mutex.synchronize { @hash }
      end
    end

    def each
      if RUBY_ENGINE == 'opal'
        @hash.each { |key, value| yield key, value }
      else
        @mutex.synchronize do
          @hash.each { |key, value| yield key, value }
        end
      end
    end
  end
end
