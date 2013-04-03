class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :address
      t.integer :votecount
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end
end
