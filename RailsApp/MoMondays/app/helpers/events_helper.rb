
module EventsHelper

	def display_modifiers_event(event)
		html = ""
		if(current_user == event.user)
			html<< "(" + link_to('Edit', edit_event_path(event)) + " | "
        	html << link_to('Delete', event, method: :delete, data:{ confirm: 'Are you sure?' })
        	html << ")"
    	end
    	return html.html_safe
	end

	def display_countdowns_and_venue_button(vote_date)
		html = ""
		html << '<h3>' + display_date_or_countdown(vote_date) + '</h3>'
		html << display_prevoting_countdown(vote_date)
		return html.html_safe
	end

	def display_date_or_countdown(vote_date)

		if vote_date.past?
			return "Time Left to Vote:</br> \<span id = 'voteCountdown'></span>\ "
		else
			return "Voting Begins On:</br>  \<span id = 'voteDate'>#{@vote_date.strftime("%B %d, %Y at %I:%M%p")}</span>\ "

		end
	end

	def display_prevoting_countdown(vote_date)
		html = ""
		#only show Suggest Venue Form if Event is in 'pre-voting' stage
		if !vote_date.past?
			html << '<p>You have <span id = "venueSuggestCountdown"></span> to suggest a venue!</p>'
		end
		
		return html
	end

	def display_event_stage(stage)
		return (stage == "Pre-Voting" ? "Venue Suggestion" : "Voting")

	end

	def generate_venue_sticky(venue)
		html = ""
		html << "#{venue.name} </br>"
		html << "Address: #{venue.address} </br>"
		if venue.url != "" 
			html << "#{link_to "Yelp Page", venue.url, :target => '_blank'} </br>"
		end

		html << "Suggested By: #{venue.user.username} </br>"
		
		html << display_modifiers_venue(venue)

		return html.html_safe

	end

end
