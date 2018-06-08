module Flexite
  class Config::Form < BaseForm
    attr_accessor :id, :name, :config_id, :created_by, :selectable
    validates :name, presence: true

    def self.model_name
      Config.model_name
    end
  end
end
