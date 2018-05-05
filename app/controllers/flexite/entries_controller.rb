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
      @entry_form = Entries::TypeForm.new(Entry.find(params[:id]).attributes)
    end

    def create
      @entry_form = Entries::NewForm.new(params[:entry])
      result = ServiceFactory.instance.get(:entry_new, @entry_form).call
      service_response(result)
    end

    def value
      @entry_form = Entries::ValueForm.new(params[:entry])
      result = ServiceFactory.instance.get(:entry_value, @entry_form).call
      service_response(result)
    end

    def update
      @entry = Entry.find(params[:id])
  
      respond_to do |format|
        if @entry.update_attributes(params[:entry])
          format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @entry.errors, status: :unprocessable_entity }
        end
      end
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
