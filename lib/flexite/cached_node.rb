module Flexite
  class CachedNode < SimpleDelegator
    def initialize(node)
      super(node.configs.each_with_object(NodesHash.new) do |sub_node, memo|
        memo[sub_node.name] = Flexite.cache.fetch(sub_node) do
          sub_node.selectable? ? sub_node.value : CachedNode.new(sub_node)
        end
      end)
    end

    def is_a?(klass)
      __getobj__.is_a?(klass)
    end

    def method_missing(name, *args, &block)
      __getobj__.send(name, *args, &block)
    end
  end
end
