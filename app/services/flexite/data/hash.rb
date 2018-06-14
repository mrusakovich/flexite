class Flexite::Data::Hash < Hashie::Mash
  extend Hashie::Extensions::DeepMerge

  def initialize(*)
    super { |h, k| h[k] = {} }
  end

  def self.name
    Hash.name
  end

  class Hashie::Array
    def self.name
      Array.name
    end
  end
end
