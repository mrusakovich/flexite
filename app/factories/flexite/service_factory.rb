module Flexite
  class ServiceFactory < BaseFactory
    def initialize
      @store = {
        arr_entry_update: 'Entry::ArrayUpdateService',
        entry_update: 'Entry::UpdateService',
        config_create: 'Config::CreateService',
        entry_create: 'Entry::CreateService',
        arr_entry_create:  'Entry::ArrayCreateService',
        entry_destroy: 'Entry::DestroyService',
        arr_entry_destroy: 'Entry::DestroyService',
        destroy_array_entry: 'Entry::DestroyArrayEntryService',
        section_create: 'Section::CreateService'
      }
    end
  end
end
