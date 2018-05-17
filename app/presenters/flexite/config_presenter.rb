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
      link_to @model.name, edit_entry_path(@model.entry), remote: true
    end

    def children
      content_tag(:li, class: 'list-group-item', onclick: "config.appendChildren(#{@model.id}, this);") do
        @model.name
      end
    end
  end
end
