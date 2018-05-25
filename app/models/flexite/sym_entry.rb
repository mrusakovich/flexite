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
end
