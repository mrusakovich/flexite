require_dependency 'flexite/application_controller'

module Flexite
  class ConfigsController < ApplicationController
    helper ConfigsHelper

    def index
      @configs = Config.tree_view(params[:config_id])
      @cache_key = "#{controller_name}/#{action_name}.#{request.format.symbol}/parent_id/#{params.fetch(:config_id, :root)}"
    end

    def new
      parent_config = Config.where(id: params[:config_id], selectable: false).first
      @config_form = Config::Form.new(config_id: parent_config.present? ? parent_config.id : nil)
    end

    def create
      result = ServiceFactory.instance.get(:config_create, Config::Form.new(config_params)).call

      if result.succeed?
        @node = result.data[:record].to_tree_node
        @parent_id = config_params[:config_id]
      end

      service_flash(result)
      service_response(result)
    end

    def edit
      @config_form = Config::Form.new(Config.find(params[:id]).attributes)
    end

    def update
      result = ServiceFactory.instance.get(:update_config, Config::Form.new(config_params)).call

      if result.succeed?
        @node = result.data[:record].to_tree_node
      end

      service_flash(result)
      service_response(result)
    end

    def destroy
      Config.destroy(params[:id])
      head :ok
    end

    def reload
      Flexite.reload_root_cache
      flash[:success] = 'Cache was reloaded'
      render partial: 'flexite/shared/show_flash'
    end

    private

    def config_params
      params[:config]
    end
  end
end
