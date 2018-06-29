module Flexite
  module ApplicationHelper
    def present(*args, presenter)
      klass = "Flexite::#{presenter.to_s.camelize}Presenter".constantize
      yield(klass.new(*args))
    end

    def back_to_app
      link_to "Back to #{Flexite.config.app_name}", Flexite.config.app_link, class: 'btn btn-default'
    end
  end
end
