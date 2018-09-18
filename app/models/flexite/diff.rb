module Flexite
  class Diff
    attr_accessor :type, :path, :changes

    def initialize(type, path, *changes)
      @type = type
      @path = path
      @changes = *changes
    end
  end
end
