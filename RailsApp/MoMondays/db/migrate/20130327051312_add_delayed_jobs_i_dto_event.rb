class AddDelayedJobsIDtoEvent < ActiveRecord::Migration
  def change
  	add_column :events, :event_email_job_id, :integer
  	add_column :events, :voting_email_job_id, :integer
  end
end
