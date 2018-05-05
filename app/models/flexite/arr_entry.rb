class Flexite::ArrEntry < Flexite::Entry
  has_many :entries, as: :entry, dependent: :destroy

  def value
    entries.select([:value, :type]).map(&:value)
  end

  def self.cast(value)
    Array.wrap(value)
  end

  def view_type
    :array
  end
end
