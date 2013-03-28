class EventFinishJob < Struct.new(:event_id)

	def perform
		@event = Event.find(event_id)
    	event.update_attributes(:stage => "Finished")
   	 	event.update_attributes(:winner => event.venues.order("votecount DESC").first.id)
    	#Automailer.event_email(event_id).deliver
	end


end
