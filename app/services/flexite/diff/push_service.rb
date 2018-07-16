module Flexite
  class Diff
    class PushService
      def initialize(stage, url)
        @stage = stage
        @remote_diff = Diff.new(url)
        @state_digest = Flexite.state_digest
      end

      def call
        checksum = Flexite.cache.read("#{@state_digest}-#{@stage}-diff-checksum")
        Flexite.cache.delete_matched(/-#{@stage}-diff-checksum/)
        Flexite.cache.delete_matched(/-#{@stage}-show-diff/)


        if checksum.blank?
          return ActionService::Result.new(flash: { type: :warning, message: 'Settings were changed and difference should be revalidated' })
        end

        response = @remote_diff.apply({ token: Flexite.config.migration_token, stage: Flexite.config.stagename, checksum: checksum })

        if response[:error].blank?
          ActionService::Result.new(flash: { type: :success, message: response[:message] })
        else
          ActionService::Result.new(flash: { type: :danger, message: "#{response[:error]}, code: #{response[:code]}" })
        end
      end
    end
  end
end
