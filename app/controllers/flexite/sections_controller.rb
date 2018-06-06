require_dependency 'flexite/application_controller'

module Flexite
  class SectionsController < ApplicationController
    def index
      respond_to do |format|
        format.html
        index_json(format)
      end
    end

    def new
      @section_form = Section::Form.new
    end

    def create
      result = ServiceFactory.instance.get(:section_create, Section::Form.new(section_params)).call

      if result.succeed?
        @node = result.data[:record].to_tree_node
      end

      service_flash(result)
      service_response(result)
    end

    def destroy
      Section.destroy(params[:id])
      head :ok
    end

    private

    def index_json(format)
      format.json do
        @parent_cache_key = "flexite/sections/#{params.fetch(:parent_id, :no_parent)}/#{controller_name}/#{action_name}.#{request.format.symbol}"
        @sections = Section.tree_view
      end
    end

    def section_params
      params[:section]
    end
  end
end
