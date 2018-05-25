module Flexite
  class ArrEntry < Entry
    has_many :entries, as: :parent, dependent: :destroy
    has_many :configs, as: :parent, dependent: :destroy, include: :entry

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
      Entry::ArrayForm.new(attributes.merge(values: value))
    end
  end
end
