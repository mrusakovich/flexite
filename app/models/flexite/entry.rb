module Flexite
  class Entry < ActiveRecord::Base
    include Presentable

    presenter :entry
    belongs_to :parent, polymorphic: true, touch: true
    attr_accessible :value
    delegate :table_name, to: 'self.class'
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
      self.value = value.to_s
    end

    def check_value
    end
  end
end
