require 'flexite/engine'
require 'simple_form'
require 'acts_as_tree'

module Flexite
  extend ActiveSupport::Autoload
  autoload :Configuration

  mattr_reader :config
  @@config = Configuration.new

  def configure
    yield(@@config)
    @@config
  end

  module_function :configure
end
