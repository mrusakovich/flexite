module Flexite
  class Entry::Form < BaseForm
    attr_accessor :id, :type, :value, :parent_id, :parent_type
    validates :type, presence: true

    def self.model_name
      Entry.model_name
    end

    def view_type
      type.demodulize.underscore
    end
  end
end
