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

	def display_countdowns_and_venue_link(vote_date)
		html = ""
		html << '<h3>' + display_date_or_countdown(vote_date) + '</h3>'
		html << '<h4>' + display_prevoting_countdown(vote_date) + '</h4>'
		return html.html_safe
	end

	def display_date_or_countdown(vote_date)

		if vote_date.past?
			return "You have \<span id = 'voteCountdown'></span>\ to vote!"
		else
			return "Voting Begins On:  \<span id = 'voteDate'>#{@vote_date.strftime("%B %d, %Y at %I:%M%p")}</span>\ "

		end
	end

	def display_prevoting_countdown(vote_date)
		html = ""
		#only show Suggest Venue Form if Event is in 'pre-voting' stage
		if !vote_date.past?
			html << '<div id = "venueEntry">'
			html << '<h4>You have <span id = "venueSuggestCountdown"></span> to suggest a venue!</h4>'
			html <<	'</div>'
		end
		
		return html
	end

	def display_event_stage(stage)
		return (stage == "Pre-Voting" ? "Venue Suggestion" : "Voting")

	end


end
