class RemoveAddressFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :address
  end

  def down
    add_column :events, :address, :string
  end
end
