class RenameOwnertoOwnerId < ActiveRecord::Migration
  def up
  	rename_column :events, :owner, :owner_id
  end

  def down
  	rename_column :events, :owner_id, :owner
  end
end
