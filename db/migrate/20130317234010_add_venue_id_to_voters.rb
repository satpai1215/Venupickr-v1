class AddVenueIdToVoters < ActiveRecord::Migration
  def up
  	add_column :voters, :references, :venue
  end

  def down
  	remove_column :voters, :references, :venue
  end
end
