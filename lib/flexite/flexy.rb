module Flexite
  class Flexy
    def self.method_missing(name, *args, &block)
      if Flexite.cached_nodes.present?
        Flexite.cached_nodes.send(name, *args, &block)
      elsif block_given?
        yield
      else
        super
      end
    end
  end
end
