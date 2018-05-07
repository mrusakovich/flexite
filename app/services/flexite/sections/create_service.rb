module Flexite
  class Sections::CreateService < ActionService
    def call
      return fail if @form.invalid?
      success
    end

    def success
      Result.new(render: false, data: Section.create(@form.attributes))
    end

    def fail
      Result.new(succeed:  false).tap do |res|
        save_errors(res)
      end
    end
  end
end
