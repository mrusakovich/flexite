module Flexite
  class Entry
    class DestroyArrayEntryService < ActionService
      def call
        if @form.id.present?
          Entry.destroy(@form.id)
        end

        success
      end

      protected

      def failure
        Result.new(success: false, endpoint: { status: 400 })
      end

      def success
        Result.new(flash: { type: :success, message: 'Entry was deleted!' })
      end
    end
  end
end
