module Flexite
  class Entry < ActiveRecord::Base
    include WithHistory

    attr_accessible :value
    history_attributes :value

    belongs_to :parent, polymorphic: true, touch: true
    has_many :histories, as: :entity, dependent: :destroy
    scope :order_by_value, -> { order(:value) }

    before_save :check_value, :cast_value

    def self.form(attributes = {})
      Form.new(attributes)
    end

    def self.service(type)
      "entry_#{type}".to_sym
    end

    alias :form_attributes :attributes

    def t_node
      {
        'value' => self[:value],
        'type' => I18n.t("models.#{self.class.name.demodulize.underscore}"),
        'class' => self.class.name
      }
    end

    def dig(level)
      send(level)
    end

    private

    def cast_value
      self[:value] = self[:value].to_s
    end

    def check_value
    end
  end
end
