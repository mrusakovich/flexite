require_dependency 'flexite/application_controller'

module Flexite
  class EntriesController < ApplicationController
    helper EntriesHelper

    def new
      klass = entry_params[:type].constantize
      @entry_form = klass.form(entry_params)
    end

    def create
      result = call_service_for(:create, entry_params)

      if result.succeed?
        @entry = result.record
        @entry_form = @entry.class.form(@entry.form_attributes)
      end

      service_flash(result)
      service_response(result)
    end

    def edit
      @entry = Entry.find(params[:id])
      @entry_form = @entry.class.form(@entry.form_attributes)
    end

    def update
      result = call_service_for(:update, entry_params)

      if result.succeed?
        @entry = Entry.find(entry_params[:id])
        @entry_form = @entry.class.form(@entry.form_attributes)
      end

      service_flash(result)
      service_response(result)
    end

    def new_array_entry
      klass = params[:type].constantize

      @prefix = params[:prefix]
      @form_options = [@prefix]

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
      result = call_service_for(:destroy, params)

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

    def call_service_for(type, entry)
      klass = entry[:type].constantize
      @entry_form = klass.form(entry)
      ServiceFactory.instance.get(klass.service(type), @entry_form).call
    end
  end
end
