module Flexite
  class History < ActiveRecord::Base
    belongs_to :entity, polymorphic: true
    has_many :history_attributes, dependent: :destroy

    after_save :check_limit

    validates_presence_of :entity

    def restore
      entity.restore(self)
    end

    private

    def check_limit
      return if entity.histories.count <= Flexite.config.history_limit
      entity.histories.order(:id).first.destroy
    end
  end
end
