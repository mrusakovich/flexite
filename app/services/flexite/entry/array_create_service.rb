module Flexite
  class Entry
    class ArrayCreateService < ActionService
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

        Entry.transaction do
          create_entries(@form.new_entries, @record.id)
        end

        success
      rescue => exc
        exc_failure(exc)
      end

      def create_entries(new_entries, parent_id)
        return if new_entries.blank?

        new_entries.each do |_, entry|
          if respond_to?("save_#{entry[:type].demodulize.underscore}", true)
            send("save_#{entry[:type].demodulize.underscore}", entry, parent_id)
          else
            save_entry(entry, parent_id)
          end
        end
      end

      def save_arr_entry(entry, parent_id)
        klass = entry[:type].constantize
        record = klass.create({ parent_id: parent_id, parent_type: klass.base_class.sti_name }, without_protection: true)
        create_entries(entry[:new_entries], record.id)
      end

      def save_entry(entry, parent_id)
        klass = entry[:type].constantize
        klass.create({ parent_id: parent_id, parent_type: klass.base_class.sti_name, value: entry[:value] }, without_protection: true)
      end

      protected

      def failure
        Result.new(success: false, endpoint: { status: 400 })
      end

      def exc_failure(exc)
        Result.new(success: false, message: exc.message, endpoint: { status: 500 })
      end

      def success
        Result.new(flash: { type: :success, message: 'Entry was created!' }, data: { record: @record })
      end
    end
  end
end
