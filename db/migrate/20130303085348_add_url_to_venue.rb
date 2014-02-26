class AddUrlToVenue < ActiveRecord::Migration
  def change
    
  end

  def up
  	remove_column :venues, :address
  	add_column :venues, :address, :text, limit: nil

  	add_column :venues, :url, :string
  end

  def down
  	remove_column :venues, :address
  	add_column :venues, :address, :string

  	remove_column :venues, :url
  end

end
