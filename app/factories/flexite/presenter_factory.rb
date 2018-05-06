module Flexite
  class PresenterFactory < BaseFactory
    def initialize
      @store = {
        entry: 'Flexite::Entries::Presenter',
        config: 'Flexite::Configs::Presenter'
      }
    end
  end
end
