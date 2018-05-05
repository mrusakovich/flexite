class Flexite::HashEntry < Flexite::Entry
  before_destroy { entries.destroy_all }

  def value
    entries.map do |entry|
      [entry.cast_v1, entry.cast_v2]
    end.to_h
  end

  def self.cast(value)
    Hash.try_convert(value)
  end

  def view_type
    :hash
  end

  private

  def entries
    Flexite::Entry
      .joins("INNER JOIN #{table_name} AS w on #{table_name}.id = w.entry_id")
      .select("#{table_name}.value AS v1, w.value AS v2, #{table_name}.type AS t1, w.type AS t2")
      .where("#{table_name}.entry_id = ?", id)
  end
end
