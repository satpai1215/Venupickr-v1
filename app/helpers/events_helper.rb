
module EventsHelper

	#event#index helper methods

	def display_edit_event(event)
		html = ""
		if(event.stage != "Archived")
			if(event.stage != nil)
				html<< link_to('Edit', edit_event_path(event), :class => 'edit-event', :remote => true)
			end
    	end
    	return html.html_safe
	end

	def display_delete_event(event)
		html = ""
		if(event.stage == "Voting")
	        html << link_to('Delete', event, method: :delete, data:{ confirm: 'Are you sure?' }, :class => 'delete-event', :remote => true)
		end
    	return html.html_safe
	end

	def display_invite_guests(event)
		html = ""
		if(event.stage != "Archived")
	        html << link_to("Invite Guests", {:controller => 'guests', :action => "new", :event_id => event.id})
		end

    	return html.html_safe
	end

	def display_reminder_link(event)
		html = ""
		if(event.stage != "Archived")
	        html << link_to("Send Reminder", {:controller => 'events', :action => "send_reminder", :event_id => event.id}, data:{confirm: 'Are you sure you want to send a reminder email to all guests?'}, remote: true)
		end

    	return html.html_safe

	end

	def timeLeft_days(event)
		html = ""
		timeLeft = (((event.event_start - event.vote_end.hours) - DateTime.now)/1.day)

		if timeLeft > 1
			html << pluralize(timeLeft.to_int.to_s, "Day")
		end

		return html.html_safe
	end


	def action_links(event)
		html = ""
		link_text = (event.stage == "Voting" ? "Go to Event Page!": "See Event Info")
		btn_type = (event.stage == "Voting" ? "btn-primary event-voting-btn": "btn-primary event-voting-btn")
		html << link_to(link_text, event_path(event), {:class => "btn #{btn_type}"})
		return html.html_safe
	end

	

	#event#show helper methods
	def display_countdowns(event)
		html = ""
		html << display_vote_countdown(event)

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

		if(event.stage == "Voting")
			html << "#{link_to "Suggest a Venue", 
			new_venue_path(:event_id => event.id), {:id => "suggestVenueLink", :class => "btn btn-info", :remote => true}}"
		end

		return html.html_safe
	end

	def display_event_stage(stage)
		return (stage == "Pre-Voting" ? "Venue Suggestion" : stage)

	end

	def generate_venue_sticky(venue)
		venue_name = h(venue.name)
		venue_address = venue.address.html_safe #to allow for <br> in the address
		venue_comments = h(venue.comments)
		html = ""
		html << "<div class = 'venueStickyHeader'>#{venue_name}</div>"
		html << "<div class = 'venueSuggestor'>Suggested By: #{venue.user.username} </div>"
		html << "<div class = 'venueStickyInfo'> <p>#{venue_address}</p>"
		if !venue.url.blank? 
			html << "<p>#{link_to "Yelp Page", venue.url, :target => '_blank'} </p> "
		end
		if !venue.comments.blank? 
			html << "<br/><div class = 'venueStickyComments'>Comments: '#{venue_comments}'</div> "
		end
		html <<"</div>"

		return html.html_safe

	end

  	def endlines_to_breaks(string)
  		string.gsub(/\n/, '<br/>').html_safe
  	end

  	def event_over_text(stage)
  		if stage == "Finished"
  			return "VENUE SET"
  		else #"Archived"
  			return "EVENT OVER"
  		end
  	end

end
