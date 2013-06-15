module VenuesHelper
	def display_modifiers_venue(venue)
		html = ""
		if venue.event.stage == "Voting"
			if(current_user == venue.user )
				html<< "(" + link_to('Edit', edit_venue_path(venue), data: {confirm: 'Are you sure? Editing the venue will reset the vote count to zero'}, :remote => true, :class => 'edit-venue') + ")|"
	    	end
	    	if(current_user == venue.event.user or current_user == venue.user)
	       		html << "(" + link_to('Remove', venue, method: :delete, data:{ confirm: 'Are you sure?' }, :remote => true, :class => 'delete-venue') + ")"
    		end
    	end

    	return html.html_safe
	end
end
