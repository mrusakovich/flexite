module Flexite
  module ApplicationHelper
    def present(model)
      unless model.respond_to?(:presenter)
        raise "#{model.class.name} is not presentable"
      end

      yield(model.presenter(self))
    end

    def back_to_app
      link_to "Back to #{Flexite.config.app_name}", Flexite.config.app_link, class: 'btn btn-default'
    end
  end
end
