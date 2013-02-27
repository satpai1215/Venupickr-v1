module EventsHelper

	def display_modifiers(event)
		html = ""
    	if current_user == event.user
       		html << "<td>" + link_to('Edit', edit_event_path(event)) + "</td>"
        	html << "<td>" + link_to('Destroy', event, method: :delete, data:{ confirm: 'Are you sure?' })
        	html << "</td>"
    	end

    	return html.html_safe
	end


end
