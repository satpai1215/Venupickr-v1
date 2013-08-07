class AddIndexestoVenue < ActiveRecord::Migration
  def up
  	add_index :venues, :user_id
    add_index :venues, :event_id
  end

  def down
  	remove_index :venues, :user_id
    remove_index :venues, :event_id
  end
end
