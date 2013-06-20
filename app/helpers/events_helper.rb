
module EventsHelper

	#event#index helper methods

	def display_edit_event(event)
		html = ""
		if(current_user == event.user)
			if(event.stage != nil)
				html<< "(" + link_to('Edit', edit_event_path(event), :class => 'edit-event', :remote => true)
				html << ")"	
			end
    	end
    	return html.html_safe
	end

	def display_delete_event(event)
		html = ""
		if(current_user == event.user)
			if(event.stage != "Finished")
	        	html << " | (" + link_to('Delete', event, method: :delete, data:{ confirm: 'Are you sure?' }, :class => 'delete-event', :remote => true)
	        	html << ")" + '<br/>'
			end
    	end
    	return html.html_safe
	end

	def display_reminder_link(event)
		html = ""
		if(current_user == event.user)
			if(event.stage != "Finished")
	        	html << link_to("Send Reminder Email", {:controller => 'events', :action => "send_reminder", :event_id => event.id}, data:{confirm: 'Are you sure you want to send a reminder email to all guests?'}, remote: true)
			end
    	end
    	return html.html_safe

	end

	def timeLeft_days(event)
		html = ""
		timeLeft = (((event.event_start - event.vote_end.hours) - DateTime.now)/1.day).to_int

		if timeLeft > 1
			html << timeLeft.to_s + " Days"
		end

		return html.html_safe
	end


	def action_links(event)
		html = ""
		link_text = "Go to Event Page!"
		html << link_to(link_text, event_path(event), {:class => "btn btn-primary event-show-btn"})
		return html.html_safe
	end
	

	#event#show helper methods
	def display_countdowns(event)
		html = ""
		html << display_vote_countdown(event)

		return html.html_safe
	end

	def display_vote_countdown(event)

		html = ""
		
		if event.stage === "Voting"
			html << "<h4>Time Left to Vote:</h4> \<span id = 'voteCountdown' class = 'infoSubHead red'>00:00:00</span>\ "
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

	def display_venue_suggest_button(event)
		html = ""

		if(event.stage != "Finished")
			html << "#{link_to "Suggest a Venue", 
			new_venue_path(:event_id => event.id), {:id => "suggestVenueLink", :class => "btn btn-info", :remote => true}}"
		end

		return html.html_safe
	end

	def display_event_stage(stage)
		return (stage == "Pre-Voting" ? "Venue Suggestion" : stage)

	end

	def generate_venue_sticky(venue)
		html = ""
		html << "<div class = 'venueStickyHeader'>#{venue.name}</div>"
		html << "<div class = 'venueSuggestor'>Suggested By: #{venue.user.username}</div>"
		html << "<div class = 'venueStickyInfo'> <p>#{venue.address}</p>"
		if !venue.url.blank? 
			html << "<p>#{link_to "Yelp Page", venue.url, :target => '_blank'} </p> "
		end
		if !venue.comments.blank? 
			html << "<br/><div class = 'venueStickyComments'>Comments: '#{venue.comments}'</div> "
		end
		html <<"</div>"

		return html.html_safe

	end

end
