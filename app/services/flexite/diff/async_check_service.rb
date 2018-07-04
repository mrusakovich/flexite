module Flexite
  class Diff
    class AsyncCheckService
      def initialize(*args, handler = Flexite.config.async_diff_handler)
        @args = args
        @handler = handler
      end

      def call
        @handler.call(*@args)
      end
    end
  end
end
