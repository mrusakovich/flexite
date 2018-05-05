class Flexite::IntEntry < Flexite::Entry
  def value
    self.class.cast(self[:value])
  end

  def self.cast(value)
    value.to_i
  end

  def view_type
    :integer
  end
end
