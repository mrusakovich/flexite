module Flexite
  class Entry < ActiveRecord::Base
    include Presentable

    belongs_to :parent, polymorphic: true, touch: true
    attr_accessible :value
    delegate :table_name, to: 'self.class'
    presenter :entry

    def view_value
      value.to_s
    end

    def view_type
      :blank
    end

    def form
      Form.new(attributes)
    end
  end
end
