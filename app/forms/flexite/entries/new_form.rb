module Flexite
  module Entries
    class NewForm < ValueForm
      validates :value, presence: true
    end
  end
end
