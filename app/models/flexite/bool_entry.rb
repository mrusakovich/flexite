module Flexite
  class BoolEntry < Entry
    def view_type
      :boolean
    end

    def form
      Entry::Form.new(attributes.merge(value: value.to_i))
    end

    private

    def check_value
      unless [1, 0].include?(value.to_i)
        errors.add(:value, 'not a boolean')
      end
    end
  end
end
