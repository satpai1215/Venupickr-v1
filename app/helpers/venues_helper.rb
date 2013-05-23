module VenuesHelper
	def display_modifiers_venue(venue)
		html = ""
		if(current_user == venue.user and venue.event.stage == "Pre-Voting")
			html = ""
			html<< link_to('Edit', edit_venue_path(venue), :remote => true, :class => 'edit-venue') + " / "
	        html << link_to('Destroy', venue, method: :delete, data:{ confirm: 'Are you sure?' }, :remote => true, :class => 'delete-venue')
    	end
    	return html.html_safe
	end
end
