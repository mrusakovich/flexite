class Flexite::BoolEntry < Flexite::Entry
  TRUE = 'true'.freeze

  def value
    self.class.cast(self[:value])
  end

  def self.cast(value)
    value == TRUE ? true : false
  end

  def view_type
    :boolean
  end
end
