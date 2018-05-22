require_dependency "flexite/application_controller"

module Flexite
  class EntriesController < ApplicationController
    def edit
      # TODO: create form factory
      # get form according entry type
      @entry = Entry.find(params[:id])
      @entry_form = Entry::Form.new(@entry.attributes)
      render layout: false
    end
  end
end
