module Flexite
  class HistoryAttribute < ActiveRecord::Base
    attr_accessible :name, :value
    belongs_to :history
  end
end
