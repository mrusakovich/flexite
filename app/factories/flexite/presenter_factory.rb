module Flexite
  class PresenterFactory < BaseFactory
    def initialize
      @store = {
        entry: 'Flexite::Entries::Presenter'
      }
    end
  end
end
