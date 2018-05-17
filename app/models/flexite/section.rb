module Flexite
  class Section < ActiveRecord::Base
    include Presentable
    include ActsAsTree
    extend ActsAsTree::TreeWalker

    presenter :section
    acts_as_tree order: :name
    attr_accessible :name
    has_many :configs, dependent: :destroy
    alias :entries :configs
  end
end
