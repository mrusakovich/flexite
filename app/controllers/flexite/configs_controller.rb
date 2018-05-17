require_dependency "flexite/application_controller"

module Flexite
  class ConfigsController < ApplicationController
    def index
      @configs = Config.all
    end

    def show
      @config = Config.find(params[:id])
    end

    def new
      @config_form = Configs::NewForm.new(section_id: params[:section_id])
    end

    def edit
      @config = Config.find(params[:id])
    end

    def create
      @config = Config.new(params[:config])

      if @config.save
        redirect_to @config, notice: 'Config was successfully created.'
      end
    end

    def update
      @config = Config.find(params[:id])

      if @config.update_attributes(params[:config])
        redirect_to @config, notice: 'Config was successfully updated.'
      end
    end

    def destroy
      @config = Config.find(params[:id])
      @config.destroy
      redirect_to configs_url
    end

    def entries
      @entries = Config.includes(:entry).where(parent_id: params[:parent_id])

      unless perform_caching
        render @entries, layout: false and return
      end

      if stale?(last_modified: @entries.maximum(:updated_at))
        render @entries, layout: false
      end
    end
  end
end
