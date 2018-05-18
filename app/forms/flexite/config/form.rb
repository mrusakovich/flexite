module Flexite
  class Config::Form < BaseForm
    attr_accessor :name, :section_id

    def self.model_name
      Config.model_name
    end
  end
end
