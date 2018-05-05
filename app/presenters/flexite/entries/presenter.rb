module Flexite
  class Entries::Presenter < BasePresenter
    def type
      @model.view_type
    end

    def value
      @model.view_value
    end
  end
end
