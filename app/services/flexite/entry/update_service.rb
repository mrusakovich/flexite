module Flexite
  class Entry::UpdateService < ActionService
    def call
      if @form.invalid?
        return failure
      end

      update_entry
    end

    private

    def update_entry
      @form.type.constantize.update(@form.id, value: @form.value)
      success
    end

    protected

    def failure
      Result.new(endpoint: { status: 400 })
    end

    def success
      Result.new
    end
  end
end
