module Flexite
  class JobReport < ActiveRecord::Base
    attr_accessible :file_name, :status

    STATUS = { in_progress: 1,
               done: 2,
               error: 3 }.freeze
  end
end
