module Flexite
  class Entry < ActiveRecord::Base
    belongs_to :parent, polymorphic: true, touch: true
    attr_accessible :value
    before_save :check_value, :cast_value

    def view_value
      value.to_s
    end

    def self.form(attributes = {})
      Form.new(attributes)
    end

    def self.service(type)
      "entry_#{type}".to_sym
    end

    alias :form_attributes :attributes

    private

    def cast_value
      self[:value] = self[:value].to_s
    end

    def check_value
    end
  end
end
