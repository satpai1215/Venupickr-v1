class RemoveAddressFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :address
    remove_column :events, :votecount
  end

  def down
    add_column :events, :address, :string
    remove_column :events, :votecount
  end
end
