module Flexite
  class Configuration
    attr_accessor :const_name, :paths, :root_cache_prefix
    attr_reader :cache

    def initialize
      @const_name = :Flexy
      @paths = {}
      @root_cache_prefix = 'all-cached-nodes'
      @cache = ActiveSupport::Cache::MemoryStore.new(size: 64.megabytes)
    end

    def cache_store=(*args)
      @cache = ActiveSupport::Cache.lookup_store(*args)

      if @cache.options[:namespace].blank?
        @cache.options[:namespace] = :flexite
      end
    end
  end
end
