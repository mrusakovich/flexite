require_dependency 'flexite/application_controller'

module Flexite
  class ConfigsController < ApplicationController
    helper ConfigsHelper

    def index
      @configs = Config.tree_view(params[:config_id])
      @cache_key = "#{controller_name}/#{action_name}.#{request.format.symbol}/#{Config.roots.maximum(:updated_at)&.to_s(:number)}"
    end

    def new
      parent_config = Config.where(id: params[:config_id], selectable: false).first
      @config_form = Config::Form.new(config_id: parent_config.present? ? parent_config.id : nil)
    end

    def create
      @config_form = Config::Form.new(config_params)
      result = ServiceFactory.instance.get(:config_create, @config_form).call

      if result.succeed?
        @node = result.record.tv_node
        @parent_id = config_params[:config_id]
      end

      service_flash(result)
      service_response(result)
    end

    def edit
      @config_form = Config::Form.new(Config.find(params[:id]).attributes)
    end

    def update
      @config_form = Config::Form.new(config_params)
      result = ServiceFactory.instance.get(:update_config, @config_form).call

      if result.succeed?
        @node = result.record.tv_node
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
