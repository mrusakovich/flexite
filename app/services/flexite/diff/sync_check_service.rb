module Flexite
  class Diff
    class SyncCheckService
      def initialize(other_tree, token, stage, checksum)
        @other_tree = other_tree
        @current_tree = Config.t_nodes
        @token = Token.new(token)
        @stage = stage
        @checksum = checksum
        @diffs = {
          '+': [],
          '-': [],
          '~': []
        }
      end

      def call
        check
      end

      protected

      def check
        if @token.invalid?
          return { error: 'Invalid token', code: 401 }
        end
        diff = HashDiff.diff(@current_tree, @other_tree, array_path: true, use_lcs: false)

        if diff.blank?
          return {}
        end

        diff.each do |type, depth, *change|
          @diffs[type.to_sym] << [get_depth(type, depth), depth, *change]
        end

        Flexite.cache.write("#{Flexite.state_digest}-#{@checksum}-#{@stage}-diffs", @diffs)
        { diffs: @diffs }
      rescue => exc
        { error: exc.message, code: 500 }
      end

      private

      def get_depth(type, depth)
        tree = get_tree(type)
        view_depth = depth.size.times.with_object([]) do |i, memo|
          sliced_depth = depth.slice(0..depth.size - 1 - i)

          case (next_node = tree.dig(*sliced_depth))
            when ::Hash
              memo << (next_node['name'] || next_node['type'])
          end
        end

        view_depth.reverse.join(Flexite.config.diff_depth_separator)
      end

      def get_tree(type)
        case type.to_sym
          when :-
            @current_tree
          else
            @other_tree
        end
      end
    end
  end
end
