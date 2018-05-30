require_dependency "flexite/application_controller"

module Flexite
  class EntriesController < ApplicationController
    helper EntriesHelper

    def edit
      respond_to do |format|
        format.js do
          @entry = Entry.find(params[:id])
          @entry_form = @entry.form
          render layout: false
        end
      end
    end

    def update
      entry = entry_params[:type].constantize.find(params[:id])
      form = entry.form(entry_params.merge(id: entry.id))
      result = ServiceFactory.instance.get(entry.service(:update), form).call
      service_response(result)
    end

    private

    def entry_params
      params[:entry]
    end
  end
end
