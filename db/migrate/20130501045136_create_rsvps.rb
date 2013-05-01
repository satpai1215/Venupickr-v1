class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.references :user
      t.references :event

      t.timestamps
    end
    add_index :rsvps, :user_id
    add_index :rsvps, :event_id
  end
end
