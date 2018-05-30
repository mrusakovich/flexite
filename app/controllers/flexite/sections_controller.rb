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
        @parent_cache_key = "#{controller_name}/parent/#{params.fetch(:parent_id, :no_parent)}/#{action_name}/#{request.format.symbol}"
        @sections = Section.tree_view(params[:parent_id])
      end
    end
  end
end
