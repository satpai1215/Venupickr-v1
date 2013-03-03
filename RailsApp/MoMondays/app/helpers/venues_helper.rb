module VenuesHelper
	def display_modifiers_venue(venue)
		if(current_user == venue.user)
			html = ""
			html<< link_to('Edit', edit_venue_path(venue)) + " | "
	        html << link_to('Destroy', venue, method: :delete, data:{ confirm: 'Are you sure?' })

	    	return html.html_safe
    	end
	end
end
