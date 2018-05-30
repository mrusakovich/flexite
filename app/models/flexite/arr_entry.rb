module Flexite
  class ArrEntry < Entry
    has_many :entries, as: :parent, dependent: :destroy

    def value
      magic_entries.map(&:value)
    end

    def view_type
      :array
    end

    def entry=(entry)
      entries << entry
    end

    def form(attributes = {})
      Entry::ArrayForm.new(attributes.present? ? attributes : self.attributes.merge(entries: magic_entries))
    end

    def service(type)
      "arr_entry_#{type}".to_sym
    end

    private

    def magic_entries
      entries.select([:id, :value, :type, :updated_at])
    end
  end
end
