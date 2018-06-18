module Flexite
  module WithHistory
    extend ActiveSupport::Concern

    included do
      after_save :save_history

      def self.history_attributes(*attributes)
        define_method :history_attributes do
          attributes
        end
      end
    end

    def restore(history)
      history.history_attributes.each do |attr|
        self[attr.name] = attr.value
      end

      self.class.skip_callback(:save, :after, :save_history)

      begin
        save!
      ensure
        self.class.set_callback(:save, :after, :save_history)
      end
    end

    private

    def save_history
      return unless changed?

      history = histories.build

      History.transaction do
        history_attributes.each do |attr|
          history.history_attributes.build(name: attr, value: self[attr])
        end

        history.save
      end

      if history.invalid?
        errors.set(:history, history.full_messages)
      end
    end
  end
end
