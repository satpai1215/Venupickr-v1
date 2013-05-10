class EventFinishJob < Struct.new(:event_id)

	def perform
		if(Event.exists?(event_id))
			@event = Event.find(event_id)
			@event.update_attributes(:stage => "Finished")
			if (@event.venues.count != 0)
	    		#ties are broken by first venue created
	   	 		@event.update_attributes(:winner => @event.venues.order("votecount DESC, created_at ASC").first.id)
	    		AutoMailer.event_email(event_id).deliver
	    	else #no_venue code
	    		@event.update_attributes(:winner => nil)
	    		AutoMailer.no_venue_email_final(event_id).deliver
    		end
    	end
	end

	handle_asynchronously :perform

end
