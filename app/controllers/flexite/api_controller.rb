module Flexite
  class ApiController < ApplicationController
    before_filter :check_token

    def configs
      @nodes = Flexite::Config.t_nodes
      render json: @nodes
    end

    private

    def check_token
      raise 'Wrong token' if Flexite::Diff::Token.new(params[:token]).invalid?
    end
  end
end
