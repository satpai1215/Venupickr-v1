class EventFinishJob < Struct.new(:event_id)

	def perform
		if(Event.exists?(event_id))
			@event = Event.find(event_id)

			if (@event.venues.count != 0)
				@event.update_column(:stage, "Finished")

				@event.venues.each do |venue|
					venue.update_attributes(:votecount => venue.voters.count)
				end
	    		#ties are broken by first venue created
	   	 		@event.update_column(:winner, @event.venues.order("votecount DESC, created_at ASC").first.id)
	    		AutoMailer.event_finish_email(event_id).deliver
	    	else #no_venue code
	    		@event.update_column(:stage, "Archived")
	    		if @event.archive_job_id and Delayed::Job.exists?(@event.archive_job_id)
     			 Delayed::Job.find(@event.archive_job_id).destroy
    			end
	    		@event.update_column(:winner, nil)
	    		AutoMailer.no_venue_email_final(event_id).deliver
    		end
    	end
	end

end
