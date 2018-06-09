module Flexite
  class Configuration
    attr_accessor :const_name, :paths, :root_cache_prefix
    attr_reader :cache

    def initialize
      @const_name = :Flexy
      @paths = {}
      @root_cache_prefix = 'all-cached-nodes'
      @cache = ActiveSupport::Cache::MemoryStore.new(default_cache_options.merge(size: 64.megabytes))
    end

    def cache_store=(store_option, options = {})
      @cache = ActiveSupport::Cache.lookup_store(store_option, default_cache_options.merge(options))
    end

    private

    def default_cache_options
      { namespace: :flexite }
    end
  end
end
