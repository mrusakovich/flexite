require 'acts_as_tree'

class Flexite::Section < ActiveRecord::Base
  include ActsAsTree
  extend ActsAsTree::TreeWalker

  acts_as_tree order: :name
  attr_accessible :name, :configs
  has_many :configs
end
