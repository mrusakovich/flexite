module Flexite
  class PresenterFactory < BaseFactory
    def initialize
      @store = {
        entry: 'Flexite::EntryPresenter',
        config: 'Flexite::ConfigPresenter',
        section: 'Flexite::SectionPresenter'
      }
    end
  end
end
