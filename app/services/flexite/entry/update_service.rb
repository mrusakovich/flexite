require_dependency 'flexite/action_service'

module Flexite
  class Entry::UpdateService < ActionService
    def call
      if @form.invalid?
        return failure
      end
      record = @form.type.constantize.find(@form.id)
      record.value = @form.value

      if record.changed?
        record.save
      end

      success
    end

    private

    protected

    def failure
      save_errors
      Result.new(success: false, endpoint: { status: 400 })
    end

    def success
      Result.new(flash: { type: :success, message: 'Entry was updated!' })
    end
  end
end
