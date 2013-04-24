class EventFinishJob < Struct.new(:event_id)

	def perform
		@event = Event.find(event_id)
    	@event.update_attributes(:stage => "Finished")
    	#ties are broken by first venue created
   	 	@event.update_attributes(:winner => (@event.venues.count != 0 ? @event.venues.order("votecount DESC, created_at ASC").first.id : nil))
    	#Automailer.event_email(event_id).deliver
	end


end
