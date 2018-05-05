module Flexite
  class ServiceFactory < BaseFactory
    def initialize
      @store = {
        section_create: 'Flexite::Sections::CreateService',
        entry_value: 'Flexite::Entries::ValueService',
        entry_new: 'Flexite::Entries::CreateService'
      }
    end
  end
end
