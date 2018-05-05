class Flexite::Config < ActiveRecord::Base
  attr_accessible :name
  belongs_to :owner, foreign_key: :created_by
  belongs_to :section
  has_one :entry
  delegate :value, to: :entry
end
