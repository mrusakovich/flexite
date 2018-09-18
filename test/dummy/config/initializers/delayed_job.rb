require 'delayed_job_active_record'

Delayed::Worker.delay_jobs          = true
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.logger              = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

module Syck
  def load_dj(yaml)
    # See https://github.com/dtao/safe_yaml
    # When the method is there, we need to load our YAML like this...
    respond_to?(:unsafe_load) ? load(yaml, safe: false) : load(yaml)
  end

  module_function :load_dj
end
