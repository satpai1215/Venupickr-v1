class VoteStartJob < Struct.new(:event_id)

	def perform
		@event = Event.find(event_id)
   		@event.update_attributes(:stage => "Voting")
    	#Automailer.vote_email(event_id).deliver
	end


end