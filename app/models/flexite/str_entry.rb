class Flexite::StrEntry < Flexite::Entry
  def value
    self.class.cast(self[:value])
  end

  def self.cast(value)
    value.to_s
  end
end
