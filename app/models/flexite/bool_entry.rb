module Flexite
  class BoolEntry < Entry
    def view_type
      :boolean
    end

    def form
      Entry::Form.new(attributes.merge(value: value.to_i))
    end
  end
end
