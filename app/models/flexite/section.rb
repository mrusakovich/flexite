class Flexite::Section < ActiveRecord::Base
  include ActsAsTree
  extend ActsAsTree::TreeWalker

  acts_as_tree order: :name
  attr_accessible :name
  has_many :configs, dependent: :destroy
  alias :entries :configs
end
