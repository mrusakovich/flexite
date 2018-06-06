module Flexite
  class Section
    class CreateService < ActionService
      def call
        if @form.invalid?
          return failure
        end

        @record = Section.create do |record|
          record.name = @form.name
        end

        success
      end

      protected

      def failure
        Result.new(success: false, endpoint: { status: 400 })
      end

      def success
        Result.new(flash: { type: :success, message: 'Section was created!' }, data: { record: @record })
      end
    end
  end
end
