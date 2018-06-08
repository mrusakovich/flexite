module Flexite
  class CachedNode < SimpleDelegator
    def initialize(node)
      @nodes = node.configs.each_with_object({}) do |node, memo|
        Flexite.cache.fetch(node) do
          memo[node.name] = node.selectable ? node.value : CachedNode.new(node)
        end
      end

      super(@nodes)
    end

    def [](name)
      @nodes[name.to_s]
    end
  end
end
