module Flexite
  class ConfigPresenter < BasePresenter
    def nodes(array)
      array << Rails.cache.fetch(@model) do
        { text: @model.name, href: treeview_href, selectable: treeview_selectable, nodes: treeview_nodes([]) }
      end
    end

    private

    def treeview_href
      if @model.configs.any?
        entries_configs_path(@model)
      elsif @model.entry.present?
        edit_entry_path(@model.entry)
      end
    end

    def treeview_selectable
      if @model.entry.present?
        true
      else
        false
      end
    end

    def treeview_nodes(nodes)
      return nil if @model.configs.blank?

      @model.configs.each_with_object(nodes) do |config, memo|
        present config do |presenter|
          presenter.nodes(memo)
        end
      end
    end
  end
end
