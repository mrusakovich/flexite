module Flexite
  class Diff
    class ApplyService
      def initialize(dir_name)
        @diffs = Dir["#{Rails.root}/config/diffs/#{dir_name}/*.yml"].map do |file_name|
          YAML.load_file(file_name)
        end.group_by(&:type)
      end

      def call
        Config.transaction(requires_new: true) do
          Entry.transaction do
            %w[~ - +].each do |type|
              next if @diffs[type].blank?

              @diffs[type].each do |diff|
                send("handle_#{diff.type}", diff.path, *diff.changes)
              end
            end
          end
        end
        ActionService::Result.new(flash: { type: :success, message: 'Difference was applied' })
      rescue StandardError => exc
        ActionService::Result.new(flash: { type: :danger, message: exc.message })
      end

      private

      define_method('handle_+') do |depth, record|
        object = dig(Config.roots, depth.slice(0..-2))
        case object
        when ActiveRecord::Relation
          create_record(record, object.first.parent)
        else
          create_record(record, object)
        end
      end

      define_method('handle_-') do |depth, _|
        record = dig(Config.roots, depth)
        record.destroy
      end

      define_method('handle_~') do |depth, _, new_value|
        attr_name = depth.last
        record = dig(Config.roots, depth.slice(0..-2))
        record.send("#{attr_name}=", new_value)
        record.save
      end

      def create_record(record, parent)
        record = record.first if record.is_a?(Array)
        record.symbolize_keys!
        record.with_indifferent_access
        new_object = record[:class].constantize.new
        new_object.parent = parent
        case new_object
        when Entry
          create_entry(new_object, record)
        when Config
          create_config(new_object, record)
        end
        new_object.save
      end

      def create_arr_entry(new_object, record)
        return if record[:entries].blank?
        record[:entries].map do |entry|
          create_record(entry, new_object)
        end
      end

      def create_entry(new_object, record)
        if new_object.is_a?(ArrEntry)
          return create_arr_entry(new_object, record)
        end

        new_object.value = record[:value]
      end

      def create_config(new_object, record)
        new_object.name = record[:name]
        new_object.description = record[:description]

        if record[:entry].present?
          create_record(record[:entry], new_object)
        elsif record[:configs].present?
          new_object.selectable = false
          record[:configs].map do |config|
            create_record(config, new_object)
          end
        end
      end

      def dig(obj, depth)
        return if obj.blank?
        depth.each do |level|
          obj = case level
                when Integer
                  obj[level]
                when String
                  obj.dig(level)
                end
        end
        obj
      end
    end
  end
end
