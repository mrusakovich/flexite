module Flexite
  class Config
    class UpdateService < ActionService
      def call
        if @form.invalid?
          return failure
        end

        @record = Config.find(@form.id)
        @record.config_id = @form.config_id
        @record.selectable = @form.selectable
        @record.name = @form.name
        @record.save
        success
      end

      protected

      def failure
        Result.new(success: false, endpoint: { status: 400 })
      end

      def success
        Result.new(flash: { type: :success, message: 'Config was updated!' }, data: @record)
      end
    end
  end
end
