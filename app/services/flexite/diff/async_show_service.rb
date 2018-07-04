module Flexite
  class Diff
    class AsyncShowService < SyncShowService
      def call
        response = Flexite.cache.read("#{Flexite.state_digest}-#{@stage}-show-diff")

        if response.present?
          return result(response)
        end

        expire_old
        nodes = File.read(File.join(Rails.root, 'tmp', 'nodes.json'))
        checksum = Digest::MD5.hexdigest(nodes)
        Flexite.cache.write("#{Flexite.state_digest}-#{@stage}-diff-checksum", checksum)
        @remote_diff.check({ token: 'test', tree: JSON.parse(f.read), stage: Flexite.config.stagename, checksum: checksum })
        ActionService::Result.new(flash: { type: :warning, message: "You will be notified via #{Flexite.config.async_diff_handler.notifier} when difference check will be completed" },
                                  endpoint: { partial: 'flexite/shared/show_flash' })
      end
    end
  end
end
