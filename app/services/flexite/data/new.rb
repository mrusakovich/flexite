module Flexite
  class Data::New
    def initialize(migrator)
      @migrator = migrator
      @errors = Hash.new { |h, k| h[k] = [] }
      @result = {}
    end

    def call
      @migrator.call.each do |section, configs|
        @result[section] = save_section(section, configs)
      end

      @result.tap do |result|
        result[:errors] = @errors
      end
    end

    private

    def save_section(section, configs)
      @result[section] = {}

      Section.create(name: section) do |record|
        begin
          save_hash_value(record, configs)
        rescue => exc
          @errors[record] << [exc.message, exc.backtrace]
        end
      end
    end

    def save_entry(parent, entry)
      send("save_#{entry.class.name.underscore}_value", parent, entry)
      raise "#{Random.rand}"
    rescue => exc
      @errors[parent] << [exc.message, exc.backtrace]
    end

    def save_hash_value(parent, hash)
      parent.selectable = false

      hash.each do |name, value|
        entry = Config.new(name: name)
        save_entry(entry, value)
        parent.configs << entry
      end
    end

    def save_array_value(parent, array)
      entry = ArrEntry.new

      array.each do |value|
        save_entry(entry, value)
      end

      parent.entry = entry
    end

    def save_symbol_value(parent, symbol)
      parent.entry = SymEntry.new(value: symbol)
    end

    def save_string_value(parent, string)
      parent.entry = StrEntry.new(value: string)
    end

    def save_true_class_value(parent, _)
      parent.entry = BoolEntry.new(value: 1)
    end

    def save_false_class_value(parent, _)
      parent.entry = BoolEntry.new(value: 0)
    end

    def save_fixnum_value(parent, fixnum)
      parent.entry = IntEntry.new(value: fixnum)
    end

    def save_nil_class_value(parent, nil_val)
      parent.entry = Entry.new(value: nil_val)
    end
  end
end
