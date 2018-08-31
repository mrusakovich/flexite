module Flexite
  class Diff
    class GetService
      include Flexite::Engine.routes.url_helpers

      def initialize(stage, endpoint)
        @stage = stage
        @token = Flexite.config.migration_token
        @endpoint = endpoint + api_configs_path(token: @token)
      end

      def call
        get_configs
        if File.exists?("#{Rails.root}/config/diffs/#{@file_name}")
          Diff::ShowService.new(@file_name).call
        else
          calculate_diff
          ActionService::Result.new(data: { file_name: @file_name })
        end
      end

      private

      def get_configs
        uri = URI(@endpoint)
        response = Net::HTTP.get(uri)
        @other_tree = JSON.parse(response)
        @current_tree = Config.t_nodes
        @file_name = "#{checksum}_#{@stage}.yml"
      end

      def calculate_diff
        Delayed::Job.enqueue(ShowDiffJob.new(@current_tree, @other_tree, @file_name))
      end

      def checksum
        @other_checksum = Digest::MD5.hexdigest(@other_tree.to_json)
        @current_checksum = Digest::MD5.hexdigest(@current_tree.to_json)
        @checksum = Digest::MD5.hexdigest("#{@other_checksum}#{@current_checksum}")
      end
    end
  end
end
