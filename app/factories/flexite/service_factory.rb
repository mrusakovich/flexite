require_dependency 'flexite/base_factory'

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
        update_config: 'Config::UpdateService',
        check_diff: 'Diff::CheckService',
        show_diff: 'Diff::ShowService',
        apply_to_diff: 'Diff::ApplyService',
        apply_from_diff: 'Diff::ApplyService'
      }
    end
  end
end
