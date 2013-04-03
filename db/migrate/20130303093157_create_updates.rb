class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.text :content
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
  end
end
