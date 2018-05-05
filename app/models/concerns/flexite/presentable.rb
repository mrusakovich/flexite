module Flexite
  module Presentable
    extend ActiveSupport::Concern

    included do
      define_singleton_method :presenter do |name|
        define_method :presenter do |view|
          PresenterFactory.instance.get(name, self, view)
        end
      end
    end
  end
end
