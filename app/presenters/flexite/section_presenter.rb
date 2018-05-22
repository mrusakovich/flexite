module Flexite
  class SectionPresenter < BasePresenter
    def nodes(array)
      array << Rails.cache.fetch(@model) do
        { text: @model.name, nodes: treeview_nodes([]), selectable: false }
      end
    end

    private

    def treeview_nodes(nodes)
      @model.configs.each_with_object(nodes) do |config, memo|
        present config do |presenter|
          presenter.nodes(memo)
        end
      end
    end
  end
end
