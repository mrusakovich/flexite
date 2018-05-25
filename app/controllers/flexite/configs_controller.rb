require_dependency "flexite/application_controller"

module Flexite
  class ConfigsController < ApplicationController
    def index
      respond_to do |format|
        format.html
        index_json(format)
      end
    end

    private

    def index_json(format)
      format.json do
        cache_key, @configs = Config.tree_view(params[:parent_id], params[:parent_type])
        render json: Rails.cache.fetch(cache_key) { @configs.map(&:to_tree_node) }
      end
    end
  end
end
