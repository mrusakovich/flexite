module Flexite
  module ApplicationHelper
    def present(model)
      unless model.respond_to?(:presenter)
        raise "#{model.class.name} is not presentable"
      end

      yield(model.presenter(self))
    end
  end
end
