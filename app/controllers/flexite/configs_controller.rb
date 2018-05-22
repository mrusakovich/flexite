require_dependency "flexite/application_controller"

module Flexite
  class ConfigsController < ApplicationController
    def index
      respond_to do |format|
        format.json do
          render json: Config.tree_view(params[:section_id]).map(&:to_tree_node)
        end
      end
    end
  end
end
