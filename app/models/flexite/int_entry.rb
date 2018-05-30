class Flexite::IntEntry < Flexite::Entry
  def value
    self[:value].to_i
  end

  def view_type
    :integer
  end

  private

  def check_value
    value.to_i
  rescue
    errors.add(:value, 'not an Integer')
  end
end
