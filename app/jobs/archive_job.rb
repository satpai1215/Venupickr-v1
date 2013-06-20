class ArchiveJob < Struct.new(:event_id)

	def perform
		if(Event.exists?(event_id))
			@event = Event.find(event_id)
			@event.update_column(:stage, "Archived")
    	end
	end

end