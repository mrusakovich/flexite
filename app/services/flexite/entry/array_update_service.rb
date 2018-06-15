require_dependency 'flexite/action_service'

module Flexite
  class Entry
    class ArrayUpdateService < ActionService
      include InnerProcessable

      def call
        if @form.invalid?
          return failure
        end

        process_entry
      end

      private

      def process_entry
        Entry.transaction(requires_new: true) do
          update_entries(@form.entries)
          create_entries
        end

        process_result('Entry was updated')
      end

      def update_entries(entries)
        entries.each do |_, entry|
          save_entry(entry)
        end
      end

      def save_entry(entry)
        call_service_for(:update, entry)
      end

      def create_entries
        return if @form.new_entries.blank?

        @form.new_entries.each do |_, entry|
          entry[:parent_id] = @form.id
          entry[:parent_type] = @form.type.constantize.base_class.sti_name
          call_service_for(:create, entry)
        end
      end

      protected

      def failure
        save_errors
        Result.new(success: false, endpoint: { status: 400 })
      end
    end
  end
end
