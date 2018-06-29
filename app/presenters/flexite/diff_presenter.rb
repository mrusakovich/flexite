module Flexite
  class DiffPresenter
    def initialize(type, depth, *changes)
      @type = type
      @depth = depth
      @changes = changes
    end

    def to_view
      case @type
        when :+
          "PATH: #{@depth}\rADDED: #{JSON.pretty_generate(@changes.first)}"
        when :-
          "PATH: #{@depth}\rDELETED: #{JSON.pretty_generate(@changes.first)}"
        when :~
          "PATH: #{@depth}\rNEW: #{@changes.first}\rOLD: #{@changes.last}"
      end
    end
  end
end
