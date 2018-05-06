module Flexite
  class Entries::CreateService < ActionService
    def call
      return fail if @form.invalid?
      success
    end

    def success
      Result.new(render: false, endpoint: Entry.create(@form.attributes.merge(type: sti_type)))
    end

    def fail
      Result.new(succeed: false).tap do |res|
        save_errors(res)
      end
    end

    private

    def sti_type
      Entry::TYPES[@form.type.to_sym]
    end
  end
end
