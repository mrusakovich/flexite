require_dependency "flexite/application_controller"

module Flexite
  class EntriesController < ApplicationController
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
      # TODO: write implementation
    end
  end
end
