require 'flexite/engine'
require 'simple_form'

module Flexite
  extend ActiveSupport::Autoload

  autoload :Configuration
  autoload :Behavior
  autoload :CachedNode
  autoload :Config

  mattr_reader :config
  @@config = Configuration.new

  class << self
    def configure
      yield(@@config)
    end

    def cache
      @@config.cache
    end

    def load
      cached_nodes # gather cached nodes
      Object.const_set(@@config.const_name, Class.new { extend Behavior })
    end

    def reload_root_cache
      cache.delete(@@config.root_cache_prefix)
      cached_nodes
    end

    def cached_nodes
      cache.fetch(@@config.root_cache_prefix) do
        Config.where(config_id: nil).each_with_object({}) do |root, memo|
          memo[root.name] = cache.fetch(root) do
            CachedNode.new(root)
          end
        end
      end
    end
  end
end
