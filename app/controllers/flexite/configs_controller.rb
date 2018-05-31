require_dependency "flexite/application_controller"

module Flexite
  class ConfigsController < ApplicationController
    def index
      if params[:parent_id].blank? || params[:parent_type].blank?
        render nothing: true, status: :bad_request and return
      end

      parent = params[:parent_type].camelize.constantize.find(params[:parent_id])
      @parent_cache_key = "#{parent.cache_key}/#{controller_name}/#{action_name}.#{request.format.symbol}"
      @configs = Config.tree_view(parent)
    end
  end
end
