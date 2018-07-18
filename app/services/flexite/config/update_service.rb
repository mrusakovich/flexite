module Flexite
  class Config
    class UpdateService < ActionService
      def call
        if @form.invalid?
          return failure
        end

        @record = Config.joins(:entry)
          .select("#{Config.table_name}.*, #{Entry.table_name}.id AS entry_id")
          .where(id: @form.id).first
        @record.update_attributes(@form.attributes)
        success
      end

      protected

      def failure
        Result.new(success: false, endpoint: { action: :edit, status: 400 })
      end

      def success
        Result.new(flash: { type: :success, message: 'Config was updated!' }, data: @record)
      end
    end
  end
end
