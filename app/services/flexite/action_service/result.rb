class Flexite::ActionService::Result
  def initialize(options = {})
    @options = options
    @errors = Hash.new { |h, k| h[k] = [] }
  end

  def succeed?
    @options.fetch(:succeed, true)
  end

  def failed?
    !succeed?
  end

  def render?
    @options.fetch(:render, true)
  end

  def redirect?
    !render?
  end

  def data
    @options[:data]
  end

  def message
    @options[:message]
  end

  alias :record :data
  alias :flash :message

  def add_error(name, value)
    @errors[name] << value
  end

  def add_errors(name, values)
    @errors[name] += values
  end

  def endpoint
    @options.fetch(:endpoint, {})
  end
end
