class UpdateEventsWithOwner < ActiveRecord::Migration
  def up
  	Event.all.each do |event|
  		event.update_column(:owner, event.user_id)
  	end
  end

  def down
  	Event.all.each do |event|
  		event.update_column(:owner, nil)
  	end
  end
end
