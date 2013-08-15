class AddVenueSuggestToEvent < ActiveRecord::Migration
  	def up
    	add_column :events, :allow_venue_suggestion, :boolean, :default => true

	  	Event.all.each do |event|
	  		event.update_column(:allow_venue_suggestion, true)
	  	end
  	end

	def down
		Event.all.each do |event|
  			event.update_column(:allow_venue_suggestion, nil)
  		end
		remove_column :events, :allow_venue_suggestion
	end
end
