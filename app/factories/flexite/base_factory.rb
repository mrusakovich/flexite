class Flexite::BaseFactory
  include Singleton

  def get(name,  *args)
    "Flexite::#{@store[name]}".constantize.new(*args)
  end
end
