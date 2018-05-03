class Flexite::Entry < ActiveRecord::Base
  belongs_to :entry, polymorphic: true

  attr_accessible :type, :value

  def cast_v1
    t1.constantize.cast(v1)
  end

  def cast_v2
    t2.constantize.cast(v2)
  end

  private

  def table_name
    self.class.table_name
  end
end
