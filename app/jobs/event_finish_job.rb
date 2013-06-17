class EventFinishJob < Struct.new(:event_id)

	def perform
		if(Event.exists?(event_id))
			@event = Event.find(event_id)
			@event.update_column(:stage, "Finished")

			if (@event.venues.count != 0)

				@event.venues.each do |venue|
					venue.update_attributes(:votecount => venue.voters.count)
				end
	    		#ties are broken by first venue created
	   	 		@event.update_column(:winner, @event.venues.order("votecount DESC, created_at ASC").first.id)
	    		AutoMailer.event_finish_email(event_id).deliver
	    	else #no_venue code
	    		@event.update_column(:winner, nil)
	    		AutoMailer.no_venue_email_final(event_id).deliver
    		end
    	end
	end

end
