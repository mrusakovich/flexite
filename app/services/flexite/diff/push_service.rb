module Flexite
  class Diff
    class PushService
      def initialize(dir_name)
        @dir_name = dir_name
        @remote_diff = Diff.new(url)
        @state_digest = Flexite.state_digest
        @checksum = checksum
      end

      def call
        if @checksum.blank?
          return ActionService::Result.new(flash: { type: :warning, message: 'Settings were changed and difference should be revalidated' })
        end

        response = @remote_diff.apply({ token: Flexite.config.migration_token, stage: Flexite.config.stagename, checksum: @checksum })

        if response[:error].blank?
          ActionService::Result.new(flash: { type: :success, message: response[:message] })
        else
          ActionService::Result.new(flash: { type: :danger, message: "#{response[:error]}, code: #{response[:code]}" })
        end
      end
    end
  end
end
