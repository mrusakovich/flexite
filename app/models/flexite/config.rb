class Flexite::Config < ActiveRecord::Base
  include Presentable
  include ActsAsTree
  extend ActsAsTree::TreeWalker
  extend ActsAsTree::TreeView

  acts_as_tree order: :name
  presenter :config
  attr_accessible :name
  belongs_to :parent, polymorphic: true, touch: true
  belongs_to :section
  belongs_to :owner, foreign_key: :created_by
  has_one :entry, as: :parent, dependent: :destroy
  has_many :configs, as: :parent, dependent: :destroy
  delegate :value, to: :entry, allow_nil: true
end
