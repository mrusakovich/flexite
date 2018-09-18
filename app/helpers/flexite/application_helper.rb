module Flexite
  module ApplicationHelper
    def present(object, klass = nil)
      begin
        klass = "#{object.class}Presenter".constantize
        presenter = klass.new(object, self)
      rescue => exc
        raise "#{object.class} is not presentable. #{exc.message}"
      end
      yield(presenter) if block_given?
      presenter
    end

    def back_to_app
      link_to "Back to #{Flexite.config.app_name}", Flexite.config.app_link, class: 'btn btn-default'
    end

    def stage_select
      select_tag :stage, options_for_select(Flexite.config.stages), class: 'form-control'
    end
  end
end
