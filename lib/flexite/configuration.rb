module Flexite
  class Configuration
    attr_accessor :paths, :root_cache_key, :source_roots, :hierarchy
    attr_accessor :app_link, :app_name, :history_limit, :migration_token
    attr_accessor :diff_depth_separator
    attr_reader :cache

    def initialize
      @paths = {}
      @root_cache_key = 'all-cached-nodes'
      @cache = ActiveSupport::Cache::MemoryStore.new(size: 64.megabytes)
      @app_link = '/'
      @source_roots = {}
      @hierarchy = {}
      @history_limit = 10
      @diff_depth_separator = ' -> '
    end

    def cache_store=(*args)
      @cache = ActiveSupport::Cache.lookup_store(*args)

      if @cache.options[:namespace].blank?
        @cache.options[:namespace] = :flexite
      end
    end
  end
end
