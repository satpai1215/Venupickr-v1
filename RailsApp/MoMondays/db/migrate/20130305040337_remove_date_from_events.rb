class RemoveDateFromEvents < ActiveRecord::Migration
  def change
  	add_column :events, :event_start, :datetime
  	add_column :events, :vote_start, :datetime
  	add_column :events, :vote_start_date, :date
  	rename_column :events, :time, :event_start_time
  	add_column :events, :event_start_date, :date
  end
  def up
  	remove_column :events, :date
  end

  def down
  	add_column :events, :date, :datetime
  end
end
