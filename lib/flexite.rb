require 'flexite/engine'
require 'hashie'
require 'hashdiff'
require 'net/http'

module Flexite
  extend ActiveSupport::Autoload

  autoload :Configuration
  autoload :Flexy
  autoload :NodesHash
  autoload :CachedNode
  autoload :Config
  autoload :Entry

  mattr_reader :config
  @@config = Configuration.new

  Object.const_set(:Flexy, Flexy)

  class << self
    def configure
      yield(@@config)
    end

    def cache
      @@config.cache
    end

    def reload_root_cache
      cache.delete(@@config.root_cache_key)
      cached_nodes
    end

    def state_digest
      Digest::MD5.hexdigest("#{Config.maximum(:updated_at)}#{Entry.maximum(:updated_at)}#{Config.count}#{Entry.count}")
    end

    def cached_nodes
      return unless Config.table_exists?

      cache.fetch(@@config.root_cache_key) do
        Config.where(config_id: nil).each_with_object(NodesHash.new) do |root, memo|
          memo[root.name] = cache.fetch(root) do
            CachedNode.new(root)
          end
        end
      end
    end
  end
end
