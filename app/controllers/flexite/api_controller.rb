module Flexite
  class ApiController < ApplicationController
    before_filter :check_token

    def configs
      @nodes = Config.t_nodes
      render json: @nodes
    end

    private

    def check_token
      if Diff::Token.new(params[:token]).invalid?
        render json: { status: 'error', code: 401, message: 'unauthorized user' }
      end
    end
  end
end
