module Flexite
  class Diff < ActiveResource::Base
    self.site = 'http://localhost:8000'
    self.collection_name = 'diff'
  end
end
