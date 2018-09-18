require_dependency 'flexite/application_controller'

module Flexite
  class DiffsController < ApplicationController
    def check
      render json: ServiceFactory.instance.get("#{Flexite.config.diff_approach}_check_diff".to_sym,
                                               params[:tree], params[:token], params[:stage], params[:checksum]).call
    end

    def apply
      result = ServiceFactory.instance.get(:apply_diff, params[:dir_name]).call

      if result.flash.present?
        service_flash(result)
      end

      service_response(result)
    end

    def save_diff
      ServiceFactory.instance.get(:save_diff, params[:stage], params[:response]).call
    end

    def show
      @result = ServiceFactory.instance.get(:show_diff, params[:dir_name]).call
    end

    def get
      @result = ServiceFactory.instance.get(:get_diff, params[:stage], params[:url]).call
      render :show
    end
  end
end
