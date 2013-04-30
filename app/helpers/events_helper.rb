
module EventsHelper

	#event#index helper methods

	def display_modifiers_event(event)
		html = ""
		if(current_user == event.user && event.stage != "Finished")
			html<< "(" + link_to('Edit', edit_event_path(event), :class => 'edit-event', :remote => true) + " | "
        	html << link_to('Delete', event, method: :delete, data:{ confirm: 'Are you sure?' }, :class => 'delete-event', :remote => true)
        	html << ")" + "<br/>"
    	end
    	return html.html_safe
	end

	def display_countdowns(event)
		html = ""
		html << '<h4>' + display_date_or_countdown(event) + '</h4>'
		html << display_prevoting_countdown(event)

		return html.html_safe
	end

	def action_links(event)
		html = ""
		link_text = (event.stage == "Pre-Voting" ? "Suggest a Venue!" : "Vote for a Venue!")
		btn_class = (event.stage == "Pre-Voting" ? "btn-info" : "btn-primary")
		html << link_to(link_text, event_path(event), {:class => "btn btn-block #{btn_class}"})
		return html.html_safe
	end
	

	#event#show helper methods

	def display_date_or_countdown(event)

		html = ""
		
		if event.stage == "Pre-Voting"
			html << "<h4>Voting Begins On:</h4>  \<span class = 'infoSubHead'>#{@vote_date.strftime("%B %d, %Y at %I:%M%p")}</span>\ "
		elsif event.stage == "Voting"
			html << "<h4>Time Left to Vote:</h4> \<span id = 'voteCountdown' class = 'infoSubHead red'></span>\ "
		else
			html << "<span id = 'eventOverHeading'>EVENT OVER</span>"
		end

		return html.html_safe
	end

	def display_venue_suggest_button(event)
		html = ""

		if(event.stage == "Pre-Voting" or current_user == event.user)
			html << "#{link_to "Suggest a Venue", 
			new_venue_path(:event_id => event.id), {:id => "suggestVenueLink", :class => "btn btn-info", :remote => true}}"
		end

		return html.html_safe
	end


	def display_prevoting_countdown(event)
		html = ""
		#only show Suggest Venue Form if Event is in 'pre-voting' stage
		if event.stage == "Pre-Voting"
			html << '<h4>Time Left for Venue Suggestion:</h4><span id = "venueSuggestCountdown" class = "infoSubHead red"></span>'
		end
		
		return html.html_safe
	end

	def display_event_stage(stage)
		return (stage == "Pre-Voting" ? "Venue Suggestion" : stage)

	end

	def generate_venue_sticky(venue)
		html = ""
		html << "<b>#{venue.name}</b> </br>"
		html << "Address: #{venue.address} </br>"
		if venue.url != "" 
			html << "#{link_to "Yelp Page", venue.url, :target => '_blank'} </br>"
		end

		html << "Suggested By: #{venue.user.username} </br>"
		
		html << display_modifiers_venue(venue)

		return html.html_safe

	end

end
