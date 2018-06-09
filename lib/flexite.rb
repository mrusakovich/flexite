require 'flexite/engine'
require 'simple_form'
require 'acts_as_tree'

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

    def cached_nodes
      cache.fetch(@@config.root_cache_prefix) do
        nodes = {}

        Config.where(config_id: nil).find_each do |root|
          nodes[root.name] = cache.fetch(root) do
            CachedNode.new(root)
          end
        end

        nodes
      end
    end
  end
end
