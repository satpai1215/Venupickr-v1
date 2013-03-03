module EventsHelper

	def display_modifiers_event(event)
		if(current_user == event.user)
			html = ""
			html<< link_to('Edit', edit_event_path(event)) + " | "
        	html << link_to('Destroy', event, method: :delete, data:{ confirm: 'Are you sure?' })

    		return html.html_safe
    	end
	end


end
