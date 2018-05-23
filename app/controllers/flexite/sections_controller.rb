require_dependency "flexite/application_controller"

module Flexite
  class SectionsController < ApplicationController
    def index
      respond_to do |format|
        format.html
        index_json(format)
      end
    end

    private

    def index_json(format)
      format.json do
        cache_key, @sections = Section.tree_view(params[:parent_id])

        render json: Rails.cache.fetch(cache_key) { @sections.map(&:to_tree_node) }
      end
    end
  end
end
