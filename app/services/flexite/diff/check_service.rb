module Flexite
  class Diff
    class CheckService
      def initialize(current_tree, other_tree, file_name)
        @other_tree = other_tree
        @current_tree = current_tree
        @file_name = file_name
      end

      def call
        check
        save
      end

      protected

      def check
        diffs = HashDiff.diff(@current_tree, @other_tree, array_path: true)

        if diffs.blank?
          return {}
        end

        @view_diffs = { '+': [], '-': [], '~': [] }

        diffs.each do |type, depth, *changes|
          @view_diffs[type.to_sym] << [depth, *changes]
        end
      end

      def save
        File.open("config/diffs/#{@file_name}", "w") do |file|
          file.write @view_diffs.to_yaml
        end
      end
    end
  end
end
