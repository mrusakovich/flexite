module Flexite
  class Sections::CreateService < BaseService
    def call
      return fail if @form.invalid?
      success
    end

    def success
      Result.new(succeed: true, render: false, data: Section.create(@form.attributes))
    end

    def fail
      Result.new(succeed:  false, render: true).tap do |res|
        save_errors(res)
      end
    end
  end
end
