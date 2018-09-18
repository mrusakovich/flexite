module Flexite
  class Diff
    class GetService
      include Flexite::Engine.routes.url_helpers

      def initialize(stage, endpoint)
        @stage = stage
        @endpoint = endpoint + api_configs_path(token: Flexite.config.migration_token)
        get_configs
      end

      def call
        if no_difference?
          ActionService::Result.new(data: { flash: { type: :success, message: 'There is no difference btw envs' } })
        elsif Dir.exist?("#{Rails.root}/config/diffs/#{@dir_name}")
          Diff::ShowService.new(@dir_name).call
        else
          calculate_diff
          ActionService::Result.new(data: { dir_name: @dir_name })
        end
      end

      private

      def get_configs
        uri = URI(@endpoint)
        response = Net::HTTP.get(uri)
        @other_tree = JSON.parse(response)
        @current_tree = Config.t_nodes
        @dir_name = "#{@stage}/#{checksum}"
      end

      def calculate_diff
        Delayed::Job.enqueue(ShowDiffJob.new(@other_tree, @current_tree, @dir_name))
      end

      def checksum
        @other_checksum = Digest::MD5.hexdigest(@other_tree.to_json)
        @current_checksum = Digest::MD5.hexdigest(@current_tree.to_json)
        @checksum = Digest::MD5.hexdigest("#{@other_checksum}#{@current_checksum}")
      end

      def no_difference?
        @other_checksum == @current_checksum
      end
    end
  end
end
