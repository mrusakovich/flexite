module Flexite
  class Entry
    module InnerProcessable
      extend ActiveSupport::Concern

      def initialize(*)
        super
        @process_result = ActionService::Result.new
      end

      private

      def call_service_for(type, entry)
        klass = entry[:type].constantize
        form = klass.form(entry)
        result = ServiceFactory.instance.get(klass.service(type), form).call

        if result.failed?
          save_inner_service_errors(@process_result, result)
        end
      end

      def process_result(success_message)
        if @process_result.succeed?
          @process_result.options[:flash] = { type: :success, message: success_message }
        end

        @process_result
      end
    end
  end
end
