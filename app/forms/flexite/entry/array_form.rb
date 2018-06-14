module Flexite
  class Entry
    class ArrayForm < Form
      attr_accessor :entries, :new_entries

      def entries
        @entries ||= []
      end
    end
  end
end
