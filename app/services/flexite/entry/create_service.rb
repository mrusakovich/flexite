require_dependency 'flexite/action_service'

module Flexite
  class Entry
    class CreateService < ActionService
      def call
        if @form.invalid?
          return failure
        end

        @record = @form.type.constantize.create do |record|
          record.value = @form.value
          record.parent_id = @form.parent_id
          record.parent_type = @form.parent_type
        end

        success
      end

      private

      def success
        Result.new(flash: { type: :success, message: 'Entry was created!' }, data: { record: @record })
      end

      def failure
        Result.new(success: false, endpoint: { status: 400 })
      end
    end
  end
end
