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

    def view_type
      :blank
    end

    def form(attributes = {})
      Form.new(attributes.present? ? attributes : self.attributes)
    end

    def service(type)
      "entry_#{type}".to_sym
    end

    private

    def cast_value
      self.value = value.to_s
    end

    def check_value
    end
  end
end
