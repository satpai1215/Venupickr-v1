class AddOwnertoEvent < ActiveRecord::Migration
	def up
    	add_column :events, :owner, :integer
  	end

	def down
		remove_column :events, :owner
	end
end
