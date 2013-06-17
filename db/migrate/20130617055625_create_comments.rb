class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content
      t.references :event
      t.references :user

      t.timestamps
    end
    add_index :comments, :event_id
    add_index :comments, :user_id
  end
end
