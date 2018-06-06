module Flexite
  class Entry::ArrayUpdateService < ActionService
    def call
      if @form.invalid?
        return failure
      end

      process_entries
    end

    private

    def process_entries
      Entry.transaction do
        update_entries(@form.entries)
        create_entries(@form.new_entries, @form.id)
      end

      success
    rescue => exc
      exc_failure(exc)
    end

    def update_entries(entries)
      entries.each do |_, entry|
        if respond_to?("save_#{entry[:type].demodulize.underscore}", true)
          send("save_#{entry[:type].demodulize.underscore}", entry)
        else
          save_entry(entry)
        end
      end
    end

    def create_entries(new_entries, parent_id)
      return if new_entries.blank?

      new_entries.each do |_, entry|
        klass = entry[:type].constantize
        klass.create({parent_id: parent_id, parent_type: klass.base_class.sti_name, value: entry[:value]}, without_protection: true)
      end
    end


    def save_arr_entry(entry)
      update_entries(entry[:entries])
      create_entries(entry[:new_entries], entry[:id])
    end

    def save_entry(entry)
      entry[:type].constantize.update(entry[:id], value: entry[:value])
    end

    protected

    def failure
      Result.new(success: false, endpoint: { status: 400 })
    end

    def exc_failure(exc)
      Result.new(success: false, message: exc.message, endpoint: { status: 500 })
    end

    def success
      Result.new(flash: { type: :success, message: 'Entry was updated!' })
    end
  end
end
