class Flexite::BasePresenter < SimpleDelegator
  def initialize(model, view)
    @model = model
    super(view)
  end
end
