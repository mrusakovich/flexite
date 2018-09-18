module Flexite
  class Diff
    class CheckService
      def initialize(current_tree, other_tree, dir_name)
        @other_tree = other_tree
        @current_tree = current_tree
        @dir_name = dir_name
      end

      def call
        check
        prepare_dir
        save
      end

      protected

      def check
        diffs = HashDiff.diff(@other_tree, @current_tree, array_path: true)
        @view_diffs = diffs.map { |type, depth, *changes| Diff.new(type, depth, *changes) }
      end

      def prepare_dir
        stage = @dir_name.split('/').first
        FileUtils.rm_rf(Dir["configs/diffs/#{stage}"])
        FileUtils.mkdir_p("config/diffs/#{@dir_name}")
      end

      def save
        @view_diffs.each_with_index do |diff, index|
          File.open("config/diffs/#{@dir_name}/#{index}.yml", "w") do |file|
            file.write(diff.to_yaml)
          end
        end
      end
    end
  end
end
