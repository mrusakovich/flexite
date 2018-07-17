module Flexite
  class ArrEntry < Entry
    has_many :entries, as: :parent, dependent: :destroy

    def value
      entries.select([:id, :value, :type]).map(&:value)
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

    def t_node
      node = super.except('value')

      if entries.any?
        node.merge!('entries' => entries.order_by_value.map(&:t_node))
      end

      node
    end

    def dig(level)
      if level.to_sym == :entries
        return send(level).order_by_value
      end

      super
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
