class ChangeUserIdtoUsernameinComments < ActiveRecord::Migration
  def up
  	remove_column :comments, :user_id
  	add_column :comments, :username, :string
  end

  def down
  	remove_column :comments, :username
  	add_column :comments, :user_id, :integer
  end
end
