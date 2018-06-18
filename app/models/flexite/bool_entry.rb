module Flexite
  class BoolEntry < Entry
    def value
      self[:value].to_i == 1 ? true : false
    end

    def form
      Entry::Form.new(attributes.merge(value: self[:value].to_i))
    end

    private

    def check_value
      unless self[:value].respond_to?(:to_i)
        errors.add(:value, 'should respond to #to_i')
        return false
      end

      unless [1, 0].include?(self[:value].to_i)
        errors.add(:value, 'not a valid boolean')
        false
      end
    end
  end
end
