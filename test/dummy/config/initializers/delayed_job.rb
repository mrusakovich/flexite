require 'delayed_job_active_record'

Delayed::Worker.delay_jobs          = true
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.logger              = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
