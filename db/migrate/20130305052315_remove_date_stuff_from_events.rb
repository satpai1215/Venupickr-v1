class RemoveDateStuffFromEvents < ActiveRecord::Migration
  def up
  	remove_column :events, :event_start_date
  	remove_column :events, :vote_start_date
  	remove_column :events, :event_start_time
  	remove_column :events, :vote_start_time
  end

  def down
  	add_column :events, :event_start_date, :date
  	add_column :events, :vote_start_date, :date
  	add_column :events, :event_start_time, :time
  	add_column :events, :vote_start_time, :time

  end
end
