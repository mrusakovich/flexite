class Flexite::IntEntry < Flexite::Entry
  def value
    self[:value].to_i
  end

  private

  def check_value
    self[:value].to_i
  rescue
    errors.add(:value, 'not an Integer')
    false
  end
end
