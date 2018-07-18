module Flexite
  class Diff
    class ApplyService
      def initialize(token, stage, checksum)
        @stage = stage
        @token = Token.new(token)
        @checksum = checksum
      end

      def call
        if @token.invalid?
          return { error: 'Invalid token', code: 401 }
        end

        diffs = Flexite.cache.read("#{Flexite.state_digest}-#{@checksum}-#{@stage}-diffs")

        if diffs.blank?
          Flexite.cache.delete_matched(Flexite.match_key("-#{@stage}-hashdiffs"))
          return { error: 'Difference is inconsistent', code: 400 }
        end

        Config.transaction(requires_new: true) do
          Entry.transaction do
            diffs.each do |type, *changes|
              send("handle_#{type}", *changes)
            end
          end
        end

        Flexite.reload_root_cache
        { message: 'Difference was applied', code: 200 }
      rescue => exc
        { error: exc.message, code: 500 }
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

      define_method('handle_~') do |depth, _, new|
        attr_name = depth.last
        record = dig(Config.roots, depth.slice(0..-2))
        record.send("#{attr_name}=", new)
        record.save
      end

      def create_record(record, parent)
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
        if record[:entries].present?
          record[:entries].map do |entry|
            create_record(entry, new_object)
          end
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
            when Fixnum
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
