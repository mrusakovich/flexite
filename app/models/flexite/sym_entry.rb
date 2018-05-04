class Flexite::SymEntry < Flexite::Entry
  def value
    self.class.cast(self[:value])
  end

  def self.cast(value)
    value.to_s.to_sym
  end
end
