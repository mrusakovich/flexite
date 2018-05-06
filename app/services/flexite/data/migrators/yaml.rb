module Flexite
  module Data
    class Migrators::Yaml
      def initialize(sections)
        @sections = sections
      end

      def call
        @sections.each_with_object({}) do |(section, paths), data|
          paths.each do |p|
            configs = YAML.load_file(p)
            data.key?(section) ? data[section].merge(configs) : data[section] = configs
          end
        end
      end
    end
  end
end
