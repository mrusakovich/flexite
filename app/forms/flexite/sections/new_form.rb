module Flexite
  class Sections::NewForm < BaseForm
    attr_accessor :name, :id
    validates :name, presence: true

    def self.model_name
      Section.model_name
    end
  end
end
