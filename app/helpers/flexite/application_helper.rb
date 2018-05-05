module Flexite
  module ApplicationHelper
    def present(model)
      yield(model.presenter(self))
    rescue NoMethodError
      raise "#{model.class.name} is not presentable"
    end
  end
end
