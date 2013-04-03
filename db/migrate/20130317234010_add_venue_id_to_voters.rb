class AddVenueIdToVoters < ActiveRecord::Migration
  def up
  	add_column :voters, :venue_id, :integer
  end

  def down
  	remove_column :voters, :venue_id, :integer
  end
end
