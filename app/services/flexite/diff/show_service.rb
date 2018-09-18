module Flexite
  class Diff
    class ShowService
      def initialize(dir_name)
        @dir_name = dir_name
      end

      def call
        @data = { dir_name: @dir_name}
        if Dir.exists?("#{Rails.root}/config/diffs/#{@dir_name}")
          @data[:diffs] = diffs
        end

        Flexite::ActionService::Result.new(data: @data)
      end

      private

      def diffs
        Dir["#{Rails.root}/config/diffs/#{@dir_name}/*.yml"].map do |file_name|
          YAML.load_file(file_name)
        end.group_by(&:type)
      end
    end
  end
end
