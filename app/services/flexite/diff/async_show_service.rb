module Flexite
  class Diff
    class AsyncShowService < SyncShowService
      def call
        response = Flexite.cache.read("#{Flexite.state_digest}-#{@stage}-show-diff")

        if response.present?
          return result(response)
        end

        expire_old
        nodes = Config.t_nodes
        checksum = Digest::MD5.hexdigest(nodes.to_json)
        Flexite.cache.write("#{Flexite.state_digest}-#{@stage}-diff-checksum", checksum)
        @remote_diff.check({ token: Flexite.config.migration_token, tree: nodes, stage: Flexite.config.stagename, checksum: checksum })
        ActionService::Result.new(flash: { type: :warning, message: "You will be notified via #{Flexite.config.async_diff_handler&.notifier} when difference check will be completed" },
                                  endpoint: { partial: 'flexite/shared/show_flash' })
      end
    end
  end
end
