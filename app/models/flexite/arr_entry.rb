module Flexite
  class ArrEntry < Entry
    has_many :entries, as: :parent, dependent: :destroy

    def value
      entries.select([:id, :value, :type]).map(&:value)
    end

    def view_type
      :array
    end

    def entry=(entry)
      entries << entry
    end

    def form
      Entry::ArrayForm.new(attributes.merge(entries: entries.select([:id, :value, :type])))
    end
  end
end
