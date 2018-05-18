module Flexite
  class Entry::Form < BaseForm
    attr_accessor :id, :type, :value

    def self.model_name
      Entry.model_name
    end
  end
end
