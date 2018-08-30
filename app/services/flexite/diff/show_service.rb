module Flexite
  class Diff
    class ShowService
      def initialize(file_name)
        @file_name = file_name
      end

      def call
        @data = { file_name: @file_name}
        if File.exists?("#{Rails.root}/config/diffs/#{@file_name}")
          @data = { diffs: YAML.load_file("#{Rails.root}/config/diffs/#{@file_name}") }
        end

        Flexite::ActionService::Result.new(data: @data)
      end
    end
  end
end
