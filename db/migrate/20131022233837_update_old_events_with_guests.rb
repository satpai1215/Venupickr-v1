class UpdateOldEventsWithGuests < ActiveRecord::Migration
  def up
  	time_now = DateTime.parse('Tue, 22 Oct 2013 16:40:49 -0700') #time of 'groups' branch merge
  	@old_events = Event.where("created_at < ?", time_now)

  	#create guest association for all users for all previous events (prior to groups branch merge)
  	@old_events.each do |e|
  		User.all.each do |user|
  			e.invite!(user.id)
  		end
  	end
  end

  def down
  	 time_now = DateTime.parse('Tue, 22 Oct 2013 16:40:49 -0700') 
  	@old_events = Event.where("created_at < ?", time_now)

  	#create guest association for all users for all previous events (prior to groups merge)
  	@old_events.each do |e|
  		e.guests.destroy_all
  	end
  end
end
