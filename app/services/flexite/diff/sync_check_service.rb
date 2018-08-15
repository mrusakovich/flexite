module Flexite
  class Diff
    class SyncCheckService
      def initialize(other_tree, token, stage, checksum)
        @other_tree = other_tree
        @current_tree = Config.t_nodes
        @token = Token.new(token)
        @stage = stage
        @checksum = checksum
      end

      def call
        check
      end

      protected

      def check
        if @token.invalid?
          return { error: 'Invalid token', code: 401 }
        end

        diffs = HashDiff.diff(@current_tree, @other_tree, array_path: true)

        if diffs.blank?
          return {}
        end

        view_diffs = { '+': [], '-': [], '~': [] }

        diffs.each do |type, depth, *changes|
          view_diffs[type.to_sym] << [depth, *changes]
        end

        Flexite.cache.write("#{Flexite.state_digest}-#{@checksum}-#{@stage}-diffs", diffs)
        { diffs: view_diffs }
      rescue => exc
        { error: exc.message, code: 500 }
      end
    end
  end
end
