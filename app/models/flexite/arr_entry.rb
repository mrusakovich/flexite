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
      node = {
        'type' => I18n.t("models.#{self.class.name.demodulize.underscore}")
      }

      if entries.any?
        node.merge!('entries' => entries.map(&:t_node))
      end

      node
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
