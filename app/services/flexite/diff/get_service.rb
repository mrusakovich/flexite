module Flexite
  class Diff
    class GetService
      include Flexite::Engine.routes.url_helpers

      def initialize(stage, endpoint)
        @stage = stage
        @token = Flexite.config.migration_token
        @endpoint = endpoint + api_configs_path(token: @token)
        @timestamps = Time.now.strftime("%Y%m%d%H%M%S")
        @file_name = "#{@timestamps}_#{@stage}.yml"
        @result = ActionService::Result.new
      end

      def call
        get_configs
        calculate_diff

        Flexite::ActionService::Result.new(data: { file_name: @file_name })
      end

      private

      def get_configs
        uri = URI(@endpoint)
        response = Net::HTTP.get(uri)
        @other_tree = JSON.parse(response)
      end

      def calculate_diff
        Delayed::Job.enqueue(ShowDiffJob.new(@other_tree, @file_name))
      end
    end
  end
end
