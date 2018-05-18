module Flexite
  class ConfigPresenter < BasePresenter
    def name
      @model.entry.present? ? edit_entry : children
    end

    def value
      @model.view_value
    end

    private

    def edit_entry
      content_tag(:li, class: 'list-group-item') do
        content_tag(:button, class: 'btn btn-link', onclick: "config.editEntry(#{@model.entry.id})") do
          @model.name
        end
      end
    end

    def children
      content_tag(:li, class: 'list-group-item', onclick: "config.appendChildren(#{@model.id}, this);") do
        @model.name
      end
    end
  end
end
