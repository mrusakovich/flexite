require 'acts_as_tree'

class Flexite::Section < ActiveRecord::Base
  include ActsAsTree

  acts_as_tree order: :name
  attr_accessible :name
end
