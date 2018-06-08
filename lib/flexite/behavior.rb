module Flexite
  module Behavior
    def for(*chain)
      cached_nodes = Flexite.cached_nodes
      return if cached_nodes.blank?

      chain.each do |name|
        cached_nodes = cached_nodes[name.to_s]
        break if cached_nodes.blank?
      end

      cached_nodes
    end
  end
end
