module Flexite
  module ApplicationHelper
    def present(*args, presenter)
      klass = "Flexite::#{presenter.to_s.camelize}Presenter".constantize
      yield(klass.new(self, *args))
    end

    def back_to_app
      link_to "Back to #{Flexite.config.app_name}", Flexite.config.app_link, class: 'btn btn-default'
    end

    def stage_select
      Rails.logger.debug { Flexite.config.stages }
      flexite_config = File.join(Rails.root, 'config', 'flexite.yml')
      Rails.logger.debug("CONFIG EXIST?: #{File.exist?(flexite_config)}")

      if File.exist?(flexite_config)
        stage_config = YAML.load_file(flexite_config)
        Rails.logger.debug { stage_config }
      end

      select_tag :stage, options_for_select(Flexite.config.stages), class: 'form-control'
    end
  end
end
