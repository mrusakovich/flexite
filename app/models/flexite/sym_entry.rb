class Flexite::SymEntry < Flexite::Entry
  def value
    self[:value].to_s.to_sym
  end

  def view_type
    :symbol
  end

  def view_value
    ":#{value}"
  end

  private

  def check_value
    value.to_sym
  rescue
    errors(:value, 'cannot be casted to Symbol')
  end
end
