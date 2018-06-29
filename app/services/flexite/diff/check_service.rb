module Flexite
  class Diff
    class CheckService
      def initialize(other_tree, token)
        @other_tree = other_tree
        @token = Token.new(token)
        @current_tree = Config.t_nodes
        @diffs = {
          '+': [],
          '-': [],
          '~': []
        }
      end

      def call
        if @token.invalid?
          return { error: 'Invalid token' }
        end

        HashDiff.diff(@other_tree, @current_tree, array_path: true, similarity: 0.5).each do |type, depth, new, old|
          send("#{type}", depth, new, old)
        end

        { diffs: @diffs, checksum: tree_checksum }
      rescue => exc
        { error: exc.message }
      end

      def inspect
        @diffs.inspect
      end

      private

      def -(depth, change, *)
        @diffs[:-] << [get_actual_depth(@other_tree, depth), change]
      end

      def +(depth, change, *)
        @diffs[:+] << [get_actual_depth(@current_tree, depth), change]
      end

      def ~(depth, new, old)
        @diffs[:~] << [get_actual_depth(@current_tree, depth), new, old]
      end

      def get_actual_depth(tree, depth)
        copy_depth = depth.dup
        humanized_depth = []

        until copy_depth.empty?
          next_node = tree.dig(*copy_depth)

          case next_node
            when ::Hash
              humanized_depth << if next_node.key?('name')
                next_node['name']
              else
                next_node['type']
              end
          end

          copy_depth.pop
        end

        humanized_depth.reverse.join(Flexite.config.diff_depth_separator)
      end

      def tree_checksum
        Digest::MD5.hexdigest(@current_tree.to_json)
      end
    end
  end
end
