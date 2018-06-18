module Flexite
  class Entry
    class ArrayForm < Form
      attr_accessor :entries, :new_entries

      def entries
        @entries ||= []
      end

      def with_history?
        false
      end
    end
  end
end
