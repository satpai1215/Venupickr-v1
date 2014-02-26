class FixAddressInVenues < ActiveRecord::Migration
  def up
  	remove_column :venues, :address
  	add_column :venues, :address, :text
  end

  def down
  	remove_column :venues, :address
  	add_column :venues, :address, :text
  end
end
