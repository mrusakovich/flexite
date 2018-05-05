require_dependency "flexite/application_controller"

module Flexite
  class SectionsController < ApplicationController
    def index
      @sections = Section.all
    end

    def show
      @section = Section.find(params[:id])
    end

    def new
      @section_form = Sections::NewForm.new
    end

    def edit
      @section_form = Sections::NewForm.new(Section.find(params[:id]).attributes)
    end

    def create
      @section_form = Sections::NewForm.new(params[:section])
      result =  ServiceFactory.instance.get(:section_create, @section_form).call

      if result.succeed?
        redirect_to result.record, notice: 'Section was successfully created.'
      else
        render action: :new
      end
    end

    def update
      @section = Section.find(params[:id])

      respond_to do |format|
        if @section.update_attributes(params[:section])
          format.html { redirect_to @section, notice: 'Section was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @section = Section.find(params[:id])
      @section.destroy

      respond_to do |format|
        format.html { redirect_to sections_url }
        format.json { head :no_content }
      end
    end
  end
end
