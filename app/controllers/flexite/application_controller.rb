require_dependency 'flexite/application_controller'

module Flexite
  class ApplicationController < ActionController::Base
    def self.inherited(subclass)
      subclass.append_view_path File.join(Flexite::Engine.root, "app/views/flexite/#{subclass.controller_name}")
    end

    def service_response(result)
      if result.render?
        render result.endpoint and return
      end

      redirect_to result.endpoint
    end
  end
end
