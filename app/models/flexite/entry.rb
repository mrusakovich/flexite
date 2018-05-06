module Flexite
  class Entry < ActiveRecord::Base
    include Presentable

    belongs_to :parent, polymorphic: true
    attr_accessible :value
    delegate :table_name, to: 'self.class'
    presenter :entry

    TYPES = {
      array: 'Flexite::ArrEntry',
      symbol: 'Flexite::SymEntry',
      string: 'Flexite::StrEntry',
      integer: 'Flexite::IntEntry',
      boolean: 'Flexite::BoolEntry'
    }.freeze

    def view_value
      value.to_s
    end

    def view_type
      :nil
    end
  end
end
