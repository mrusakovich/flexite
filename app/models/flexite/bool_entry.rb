module Flexite
  class BoolEntry < Entry
    TRUE = 'true'.freeze

    def view_type
      :boolean
    end

    def form
      Entry::Form.new(attributes.merge(value: value == TRUE ? 1 : 0))
    end
  end
end
