module Flexite
  class Diff
    class AsyncCheckService
      def initialize(*args)
        @args = args
        @handler = Flexite.config.async_diff_handler
      end

      def call
        unless @handler.is_a?(Proc)
          raise 'Async handler should be a proc object'
        end

        @handler.call(*@args)
      end
    end
  end
end
