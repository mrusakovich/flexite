module Flexite
  class BoolEntry < Entry
    def value
      self[:value].to_i  == 1 ? true : false
    end

    def form
      Entry::Form.new(attributes.merge(value: self[:value].to_i))
    end

    private

    def check_value
      unless [1, 0].include?(self[:value].to_i)
        errors.add(:value, 'not a boolean')
      end
    end
  end
end
