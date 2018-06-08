module Flexite
  module Data
    class Migrators::Yaml
      def initialize(roots)
        @roots = roots
      end

      def call
        @roots.each_with_object(data) do |(root, paths), data|
          paths.each do |p|
            configs = YAML.load_file(p)
            data[root].merge!(configs)
          end
        end
      end

      private

      def data
        Hash.new { |h, k| h[k] = {} }
      end
    end
  end
end
