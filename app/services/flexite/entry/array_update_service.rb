module Flexite
  class Entry::ArrayUpdateService < ActionService
    def call
      if @form.invalid?
        return failure
      end

      update_entries
    end

    private

    def update_entries
      Entry.transaction do
        save_entries(@form.entries)
      end

      success
    rescue => exc
      exc_failure(exc)
    end

    def save_entries(entries)
      entries.each do |_, entry|
        send("save_#{entry[:type].demodulize.underscore}", entry) rescue save_entry(entry)
      end
    end


    def save_arr_entry(entry)
      save_entries(entry[:entries])
    end

    def save_entry(entry)
      entry[:type].constantize.update(entry[:id], value: entry[:value])
    end

    protected

    def failure
      Result.new(endpoint: { status: 400 })
    end

    def exc_failure(exc)
      Result.new(message: exc.message, endpoint: { status: 500 })
    end

    def success
      Result.new
    end
  end
end
