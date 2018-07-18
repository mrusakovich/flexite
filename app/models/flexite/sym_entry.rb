class Flexite::SymEntry < Flexite::Entry
  def value
    self[:value].to_sym
  end

  private

  def check_value
    self[:value].to_sym
  rescue
    errors(:value, 'cannot be casted to Symbol')
    false
  end
end
