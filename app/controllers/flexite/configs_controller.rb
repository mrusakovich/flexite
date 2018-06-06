require_dependency 'flexite/application_controller'

module Flexite
  class ConfigsController < ApplicationController
    helper ConfigsHelper
    helper EntriesHelper

    def new
      @config_form = Config::Form.new
    end

    def create
      result = ServiceFactory.instance.get(:config_create, Config::Form.new(config_params)).call

      if result.succeed?
        @node = result.data[:record].to_tree_node
        @parent_id = config_params[:parent_id]
        @parent_type = config_params[:parent_type]
      end

      service_flash(result)
      service_response(result)
    end

    def destroy
      Config.destroy(params[:id])
      head :ok
    end

    private

    def config_params
      params[:config]
    end
  end
end
