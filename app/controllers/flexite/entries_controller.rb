require_dependency 'flexite/application_controller'

module Flexite
  class EntriesController < ApplicationController
    helper EntriesHelper

    def new
      klass = entry_params[:type].constantize
      @entry_form = klass.form(entry_params)
    end

    def create
      klass = entry_params[:type].constantize
      form = klass.form(entry_params)
      result = ServiceFactory.instance.get(klass.service(:create), form).call

      if result.succeed?
        @entry = result.data[:record]
        @entry_form = @entry.class.form(@entry.form_attributes)
      end

      service_flash(result)
      service_response(result)
    end

    def edit
      @entry = Entry.find_by_id(params[:id])
      @entry_form = @entry.class.form(@entry.form_attributes)
    end

    def update
      klass = entry_params[:type].constantize
      form = klass.form(entry_params)
      result = ServiceFactory.instance.get(klass.service(:update), form).call
      service_flash(result)
      service_response(result)
    end

    def new_array_entry
      klass = params[:type].constantize
      @form_options = [params[:prefix]]

      if (@form_index = params[:form_index]).present?
        @form_options << { index: @form_index }
      end

      @parent_id = params[:parent_id]
      @index = params[:index]
      @entry_form = klass.form(klass.new.form_attributes)
    end

    def destroy_array_entry
      result = ServiceFactory.instance.get(:destroy_array_entry, Entry.form(params)).call
      @selector = params[:selector]
      service_flash(result)
      service_response(result)
    end

    def destroy
      klass = params[:type].constantize
      form = klass.form(id: params[:id])
      result = ServiceFactory.instance.get(klass.service(:destroy), form).call

      if result.succeed?
        @parent_id = result.data[:parent_id]
      end

      service_flash(result)
      service_response(result)
    end

    def select_type
      @config = Config.find(params[:parent_id])
    end

    private

    def entry_params
      params[:entry]
    end
  end
end
