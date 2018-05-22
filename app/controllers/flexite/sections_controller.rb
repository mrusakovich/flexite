require_dependency "flexite/application_controller"

module Flexite
  class SectionsController < ApplicationController
    def index
      respond_to do |format|
        format.html
        format.json do
          render json: Section.tree_view(params[:parent_id]).map(&:to_tree_node)
        end
      end
    end
  end
end
