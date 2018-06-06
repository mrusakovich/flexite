module Flexite
  class ArrEntry < Entry
    has_many :entries, as: :parent, dependent: :destroy

    def value
      magic_entries.map(&:value)
    end

    def entry=(entry)
      entries << entry
    end

    def form_attributes
      attributes.merge(entries: form_entries)
    end

    def self.form(attributes = {})
      Entry::ArrayForm.new(attributes)
    end

    def self.service(type)
      "arr_entry_#{type}".to_sym
    end

    private

    def form_entries
      entries.select([:id, :value, :type, :updated_at])
    end

    def cast_value
      # value should be blank
    end
  end
end
