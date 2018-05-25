module Flexite
  module Data
    class Migrators::Yaml
      def initialize(sections)
        @sections = sections
      end

      def call
        @sections.each_with_object(data) do |(section, paths), data|
          paths.each do |p|
            configs = YAML.load_file(p)
            data[section].merge!(configs)
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
