module Flexite
  class Entries::ValueService < BaseService
    def call
      return fail if @form.invalid?
      success
    end

    def success
      Result.new(endpoint: { template: "values/#{@form.type}" })
    end

    def fail

    end
  end
end
