module Flexite
  class ServiceFactory < BaseFactory
    def initialize
      @store = {
        arr_entry_update: 'Entry::ArrayUpdateService',
        entry_update: 'Entry::UpdateService'
      }
    end
  end
end
