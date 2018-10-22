module Flexite
  class Data::Migrators::Yaml
    def initialize
      @paths = Flexite.config.paths
      @roots = Flexite.config.source_roots
      @hierarchy = Flexite.config.hierarchy
      @data = Data::Hash.new
    end

    def call
      @paths.each_with_object(@data) do |(name, paths), data|
        paths.each do |p|
          next unless File.exists?(p)

          load_data(data, name, p)
        end
      end
    end

    private

    def load_data(data, name, path)
      with_hierarchy(path) do |configs|
        with_source_roots(data[name], configs)
      end
    end

    def with_source_roots(data, configs)
      data.deep_merge!(configs[Rails.env] || configs)
    end

    # hierarchy = [:a, :b, :c]
    #
    # {
    #   a: {
    #         b: {
    #              c: {}
    #            }
    #      }
    # }
    #
    #

    def with_hierarchy(path)
      hierarchy = @hierarchy[path]
      return yield(YAML.load_file(path)) if hierarchy.blank?

      new_hash = {}
      leveling = new_hash
      hierarchy.each do |level|
        leveling = leveling[level] = {}
      end

      leveling.merge!(YAML.load_file(path))
      yield(new_hash)
    end
  end
end
