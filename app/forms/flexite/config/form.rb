module Flexite
  class Config::Form < BaseForm
    attr_accessor :id, :name, :parent_id, :parent_type, :created_by, :selectable
    validates :name, :parent_id, :parent_type, presence: true

    def self.model_name
      Config.model_name
    end
  end
end
