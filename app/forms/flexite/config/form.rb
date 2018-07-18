require_dependency 'flexite/base_form'

module Flexite
  class Config::Form < BaseForm
    attr_accessor :id, :name, :config_id, :created_by, :selectable, :description
    validates :name, presence: true

    def self.model_name
      Config.model_name
    end

    def history_type
      Config.name.underscore
    end
  end
end
