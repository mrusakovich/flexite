require_dependency 'flexite/action_service'

module Flexite
  class Entry
    class ArrayCreateService < ActionService
      include InnerProcessable

      def call
        if @form.invalid?
          return failure
        end

        process_entry
      end

      private

      def process_entry
        @record = ArrEntry.create do |record|
          record.parent_id = @form.parent_id
          record.parent_type = @form.parent_type
        end

        Entry.transaction(requires_new: true) do
          create_entries(@form.new_entries)
        end

        if @process_result.succeed?
          @process_result.options[:data] = @record
        end

        process_result('Entry was created')
      end

      def create_entries(new_entries)
        return if new_entries.blank?

        new_entries.each do |_, entry|
          entry[:parent_id] = @record.id
          entry[:parent_type] = @form.type.constantize.base_class.sti_name
          save_entry(entry)
        end
      end

      def save_entry(entry)
        call_service_for(:create, entry)
      end

      protected

      def failure
        save_errors
        Result.new(success: false, endpoint: { status: 400 })
      end
    end
  end
end
