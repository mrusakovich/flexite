require_dependency 'flexite/base_form'

module Flexite
  class Entry::Form < BaseForm
    attr_accessor :id, :type, :value, :parent_id, :parent_type
    validates :type, presence: true

    def self.model_name
      Entry.model_name
    end

    def view_type
      type.demodulize.underscore
    end

    def history_type
      Entry.name.underscore
    end

    def with_history?
      persisted?
    end
  end
end
