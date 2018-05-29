module Flexite
  class Entry::ArrayForm < BaseForm
    attr_accessor :id, :type, :entries

    def self.model_name
      Entry.model_name
    end
  end
end
