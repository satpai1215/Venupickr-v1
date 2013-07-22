class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.references :user
      t.references :event

      t.timestamps
    end
    add_index :guests, :user_id
    add_index :guests, :event_id
  end
end
