class Flexite::ActionService
  def self.inherited(child)
    child.const_set(:Result, Result)
  end

  def initialize(form, params = {})
    @form = form
    @params = params
  end

  def call
    raise NotImplementedError
  end

  protected

  def success
    raise NotImplementedError
  end

  def fail
    raise NotImplementedError
  end

  def save_errors(result)
    @form.errors.messages.each do |key, values|
      result.add_errors(key, values)
    end
  end
end
