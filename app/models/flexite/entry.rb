class Flexite::Entry < ActiveRecord::Base
  include Presentable

  belongs_to :entry, polymorphic: true
  belongs_to :config
  attr_accessible :type, :value
  delegate :table_name, to: 'self.class'
  presenter :entry

  TYPES = {
    hash: 'Flexite::HashEntry',
    array: 'Flexite::ArrEntry',
    symbol: 'Flexite::SymEntry',
    string: 'Flexite::StrEntry',
    integer: 'Flexite::IntEntry',
    boolean: 'Flexite::BoolEntry'
  }.freeze

  def cast_v1
    t1.constantize.cast(v1)
  end

  def cast_v2
    t2.constantize.cast(v2)
  end

  def view_value
    value.to_s
  end
end
