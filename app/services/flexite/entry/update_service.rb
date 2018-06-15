require_dependency 'flexite/action_service'

module Flexite
  class Entry::UpdateService < ActionService
    def call
      if @form.invalid?
        return failure
      end

      @form.type.constantize.update(@form.id, value: @form.value)
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
