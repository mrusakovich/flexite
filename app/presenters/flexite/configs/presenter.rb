module Flexite
  class Configs::Presenter < BasePresenter
    def name(level)
      link_to "#{level} #{@model.name}", config_path(@model), style: 'font-size: 16pt'
    end

    def value
      @model.value
    end

    def value?
      !@model.value.nil?
    end
  end
end
