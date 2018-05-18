require_dependency "flexite/application_controller"

module Flexite
  class EntriesController < ApplicationController
    def index
      @entries = Entry.all
  
      respond_to do |format|
        format.html
        format.json { render json: @entries }
      end
    end

    def show
      @entry = Entry.find(params[:id])
  
      respond_to do |format|
        format.html
        format.json { render json: @entry }
      end
    end

    def new
      @entry_form = Entries::TypeForm.new
    end

    def edit
      @entry = Entry.find(params[:id])
      @entry_form = Entry::Form.new(@entry.attributes)
      render layout: false
    end

    def create
      binding.pry
      # @entry_form = Entries::NewForm.new(params[:entry])
      # result = ServiceFactory.instance.get(:entry_new, @entry_form).call
      # service_response(result)
    end

    def value
      @entry_form = Entries::ValueForm.new(params[:entry])
      result = ServiceFactory.instance.get(:entry_value, @entry_form).call
      service_response(result)
    end

    def update
      binding.pry
    end

    def destroy
      @entry = Entry.find(params[:id])
      @entry.destroy
  
      respond_to do |format|
        format.html { redirect_to entries_url }
        format.json { head :no_content }
      end
    end
  end
end
