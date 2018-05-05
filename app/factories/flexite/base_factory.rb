class Flexite::BaseFactory
  include Singleton

  def get(name,  *args)
    @store[name].safe_constantize&.new(*args)
  end
end
