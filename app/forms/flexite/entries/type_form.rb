module Flexite
  class Entries::TypeForm < BaseForm
    attr_accessor :type
    validates :type, presence: true

    def self.model_name
      Entry.model_name
    end
  end
end
