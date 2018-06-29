require_dependency 'flexite/application_controller'

module Flexite
  class DiffsController < ApplicationController
    def check
      render json: ServiceFactory.instance.get(:check_diff, params[:tree], params[:token]).call
    end

    def apply

    end

    def show
      @diffs = ServiceFactory.instance.get(:show_diff).call
    end
  end
end
