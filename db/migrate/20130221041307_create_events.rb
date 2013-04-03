class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.string :address
      t.integer :votecount

      t.timestamps
    end
  end
end
