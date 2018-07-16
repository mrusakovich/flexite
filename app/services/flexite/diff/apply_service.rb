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
            handle_delete(diffs[:-])
            handle_add(diffs[:+])
            handle_change(diffs[:~])
          end
        end

        { message: 'Difference was applied', code: 200 }
      rescue => exc
        { error: exc.message, code: 500 }
      end

      private

      def handle_delete(changes)
        changes.each do |_, depth, _|
          record = dig(Config.roots, depth)
          record.destroy
        end
      end

      def handle_add(changes)
        changes.each do |_, depth, record|
          assoc, level = depth.last(2)
          object = dig(Config.roots, depth - [level])

          if object.is_a?(Array)
            parent = get_parent(object.first)
            object.insert(level, create_record(record, parent))
            parent.send("#{assoc}=", object)
            parent.save
          else
            create_record(record, object)
            object.save
          end
        end
      end

      def handle_change(changes)
        changes.each do |_, depth, _, new|
          attr_name = depth.pop
          record = dig(Config.roots, depth)
          record.send("#{attr_name}=", new)
          record.save
        end
      end

      def create_record(record, parent)
        new_object = record[:class].constantize.new

        case new_object
          when Entry
            create_entry(new_object, record, parent)
          when Config
            create_config(new_object, record, parent)
        end
      end

      def create_arr_entry(new_object, record, parent)
        new_object.parent = parent

        if record[:entries].present?
          new_object.entries = record[:entries].map do |entry|
            create_entry(entry[:class].constantize.new, entry, new_object)
          end
        end

        new_object.save
        new_object
      end

      def create_entry(new_object, record, parent)
        if new_object.is_a?(ArrEntry)
          return create_arr_entry(new_object, record, parent)
        end

        new_object.value = record[:value]
        new_object.parent = parent
        new_object.save
        new_object
      end

      def create_config(new_object, record, parent)
        new_object.name = record[:name]
        new_object.description = record[:description]
        new_object.config = parent

        if record[:entry].present?
          new_object.entry = create_entry(record[:entry][:class].constantize.new, record[:entry], new_object)
        end

        new_object.save
        new_object
      end

      def get_parent(object)
        case object
          when Config
            object.config
          when Entry
            object.parent
        end
      end

      def dig(obj, depth)
        level = depth.shift

        case level
          when Fixnum
            dig(obj[level], depth)
          when String
            dig(obj.send(level), depth)
          else
            obj
        end
      end
    end
  end
end
