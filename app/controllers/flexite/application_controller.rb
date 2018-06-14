require_dependency 'flexite/service_factory'

module Flexite
  class ApplicationController < ActionController::Base
    append_view_path File.join(Flexite::Engine.root, "app/views/flexite/#{controller_name}")

    def self.inherited(subclass)
      subclass.append_view_path File.join(Flexite::Engine.root, "app/views/flexite/#{subclass.controller_name}")
    end

    private

    def service_response(result)
      if result.render?
        render result.endpoint and return
      end

      redirect_to result.endpoint
    end

    def service_flash(result)
      flash.now[result.flash[:type]] = result.flash[:message]
    end
  end
end
