class FixDateTypesinEvents < ActiveRecord::Migration
  def change
  	add_column :events, :event_start, :datetime
  	add_column :events, :vote_start, :datetime
  end
end
