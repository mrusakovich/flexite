require_dependency 'flexite/action_service'

module Flexite
  class Config::CreateService < ActionService
    def call
      if @form.invalid?
        return failure
      end

      @record = Config.create(@form.attributes, without_protection: true)
      success
    end

    protected

    def failure
      Result.new(success: false, endpoint: { status: 400 })
    end

    def success
      Result.new(flash: { type: :success, message: 'Config was created!' },
                 data: { record: @record })
    end
  end
end
