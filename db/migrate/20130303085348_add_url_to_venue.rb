class AddUrlToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :url, :string
    change_column :venues, :address, :text
  end
end
