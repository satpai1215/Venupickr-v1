class VoteStartJob < Struct.new(:event_id)

	def perform
		if(Event.exists?(event_id))
			@event = Event.find(event_id)
   			@event.update_attributes(:stage => "Voting")
   			if (@event.venues.count != 0)
	    		AutoMailer.vote_email(event_id).deliver
	    	else #no_venue code
	    		AutoMailer.no_venue_email(event_id).deliver
    		end
    		
    	end
	end

end