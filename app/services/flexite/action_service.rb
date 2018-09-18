module Flexite
  class ActionService
    def initialize(form, params = {})
      @form = form
      @params = params
    end

    def call
      raise NotImplementedError
    end

    protected

    def failure
      save_errors
      Result.new(success: false, endpoint: { status: 400 })
    end

    def save_errors(result)
      @form.errors.messages.each do |key, values|
        result.add_errors(key, values)
      end
    end

    def save_inner_service_errors(result, inner_result)
      return if inner_result.errors.blank?
      result.options[:succeed] = false if result.succeed?

      inner_result.errors.each do |name, values|
        result.add_errors(name, values)
      end
    end
  end
end
require_dependency 'flexite/action_service/result'
