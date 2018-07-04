module Flexite
  class Diff
    class SaveDiffService
      def initialize(stage, response)
        @stage = stage
        @response = response
      end

      def call
        Flexite.write("#{Flexite.state_digest}-#{@stage}-show-diff", @response)
      end
    end
  end
end
