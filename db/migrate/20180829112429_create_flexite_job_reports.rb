class CreateFlexiteJobReports < ActiveRecord::Migration
  def change
    create_table :flexite_job_reports do |t|
      t.string  :file_name
      t.integer :status
      t.timestamps
    end
  end
end
