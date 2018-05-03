class Flexite::BoolEntry < Flexite::Entry
  TRUE = 'true'.freeze
  FALSE = 'false'.freeze

  def value
    self.class.cast(self[:value])
  end

  def self.cast(value)
    value == '1' ? true : false
  end
end
