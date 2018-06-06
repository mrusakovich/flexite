require_dependency 'flexite/application_controller'

module Flexite
  class ParentsController < ApplicationController
    def select
      if params[:parent_type].blank?
        @clear = true
        return
      end

      relation = params[:parent_type].constantize.parent_dropdown

      # TODO: use stale? instead
      @parents = Rails.cache.fetch("#{controller_name}/#{action_name}/#{Digest::MD5.hexdigest(relation.to_sql)}-#{relation.maximum(:updated_at).to_i}") do
        relation.map { |parent| [parent.name, parent.id] }
      end

      render layout: false
    end

    def configs
      if params[:parent_id].blank? || params[:parent_type].blank?
        render nothing: true, status: :bad_request and return
      end

      parent = params[:parent_type].camelize.constantize.find(params[:parent_id])
      @parent_cache_key = "#{parent.cache_key}/#{controller_name}/#{action_name}.#{request.format.symbol}"
      @configs = Config.tree_view(parent)
    end
  end
end
