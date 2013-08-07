class AddUniqueIndexForEventandUsers < ActiveRecord::Migration
  def change
  	add_index :guests, [:user_id, :event_id], unique: true
  end
end
