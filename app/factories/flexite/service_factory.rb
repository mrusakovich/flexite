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
        apply_diff: 'Diff::ApplyService',
        push_diff: 'Diff::PushService',
        get_diff: 'Diff::GetService',
        show_diff: 'Diff::ShowService'
      }
    end
  end
end
