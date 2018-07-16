module Flexite
  class DiffPresenter < SimpleDelegator
    def initialize(template, type, depth, _, *changes)
      @type = type
      @depth = depth
      @changes = changes
      super(template)
    end

    def to_view
      "PATH: #{@depth}\r#{t("labels.diff.operations.#{@type}") % prettified}"
    end

    private

    def prettified
      case @type.to_sym
        when :-, :+
          JSON.pretty_generate(@changes.first) rescue @changes.first
        else
          @changes
      end
    end
  end
end
