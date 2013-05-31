module VenuesHelper
	def display_modifiers_venue(venue)
		html = ""
		if(current_user == venue.user )
			html = ""
			html<< link_to('Edit', edit_venue_path(venue), data: {confirm: 'Are you sure? Editing the venue will reset the vote count to zero'}, :remote => true, :class => 'edit-venue') + " / "
	        html << link_to('Remove', venue, method: :delete, data:{ confirm: 'Are you sure?' }, :remote => true, :class => 'delete-venue')
    	end
    	return html.html_safe
	end
end
