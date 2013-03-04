class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.references :event
      t.references :user

      t.timestamps
    end
    add_index :voters, :event_id
    add_index :voters, :user_id
  end
end
