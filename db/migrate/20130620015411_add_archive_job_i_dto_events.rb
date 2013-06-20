class AddArchiveJobIDtoEvents < ActiveRecord::Migration
	def change
    	add_column :events, :archive_job_id, :integer
  	end
end
