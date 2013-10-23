class AddGoingToGuest < ActiveRecord::Migration
  def change
  	add_column :guests, :isgoing, :boolean, :default => false
  end
end
