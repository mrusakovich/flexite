require_dependency 'flexite/application_controller'

module Flexite
  class HistoriesController < ApplicationController
    def index
      @histories = History.includes(:history_attributes).where(entity_id: params[:entity_id], entity_type: params[:entity_type].camelize)
    end

    def restore
      History.includes(:history_attributes).find(params[:id]).restore
      flash[:success] = 'Entity was restored from history'
    end
  end
end
