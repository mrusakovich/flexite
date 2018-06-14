require_dependency 'flexite/action_service'

module Flexite
  class Entry
    class DestroyService < ActionService
      def call
        @record = Entry.destroy(@form.id)
        success
      end

      protected

      def failure
        Result.new(success: false, endpoint: { status: 400 })
      end

      def success
        Result.new(flash: { type: :success, message: 'Entry was deleted!' }, data: { parent_id: @record.parent_id })
      end
    end
  end
end
