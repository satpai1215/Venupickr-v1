class AddUnRegGuestsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :unregistered_guests, :text
  end
end
