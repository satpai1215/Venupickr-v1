module EventsHelper

	def display_modifiers(event)
		html = ""
    	if current_user == event.user
       		html << link_to('Edit', edit_event_path(event)) + " | "
        	html << link_to('Destroy', event, method: :delete, data:{ confirm: 'Are you sure?' })
    	end

    	return html.html_safe
	end


end
