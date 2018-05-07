module Flexite
  class Configs::Presenter < BasePresenter
    def name(level)
      link_to "#{level} #{@model.name}:", config_path(@model), style: 'font-size: 16pt'
    end

    def value
      content_tag(:span, style: 'font-size: 16pt') do
        @model.entry.view_value
      end
    end

    def value?
      !@model.value.nil?
    end
  end
end
