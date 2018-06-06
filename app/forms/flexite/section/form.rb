module Flexite
  class Section::Form < BaseForm
    attr_accessor :id, :name, :parent_id

    def self.model_name
      Section.model_name
    end
  end
end
