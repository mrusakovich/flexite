class Flexite::ArrEntry < Flexite::Entry
  has_many :entries, as: :parent, dependent: :destroy
  has_many :configs, as: :parent, dependent: :destroy, include: :entry

  def value
    entries.map(&:value).tap do |values|
      configs.each do |config|
        values << { config.name => config.entry.value }
      end
    end
  end

  def self.cast(value)
    Array.wrap(value)
  end

  def view_type
    :array
  end

  def entry=(entry)
    entries << entry
  end
end
