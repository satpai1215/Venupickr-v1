module EventsHelper

	def display_modifiers_event(event)
		if(current_user == event.user)
			html = ""
			html<< "(" + link_to('Edit', edit_event_path(event)) + " | "
        	html << link_to('Delete', event, method: :delete, data:{ confirm: 'Are you sure?' })
        	html << ")"

    		return html.html_safe
    	end
	end

	def check_event_stage(event)

		if (event.event_start - event.vote_start.days).past?
			event.stage = "Voting"
		else
			event.stage = "Pre-voting"
		end

		return event.stage
	end

	def display_date_or_countdown(vote_date)

		if(vote_date).past?
			return "You have \<span id = 'voteCountdown'></span>\ to vote!".html_safe
		else
			return "Voting Begins On:  \<span id = 'voteDate'>#{@vote_date.strftime("%B %d, %Y at %I:%M%p")}</span>\ ".html_safe

		end
	end

	def display_event_stage(event)
		if(event.stage == "Pre-voting")
			return "Venue Suggestion"

		else
			return "Voting"
		end

	end


end
