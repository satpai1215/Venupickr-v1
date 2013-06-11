- Validate upon change of event date (disabled)
- redirect on sign in to previous page (done)
- highlight winning venue on Event Finished page  (done)
- add graphic for loading (esp when events are created to prevent double submission)
- What to do if event has no venues suggested and countdown ends (done)
- have a checkbox to determine if people other than event_owner can suggest venues (optional)
- email users when events are created (tell them to suggest venues)
- allow users to remove name from RSVP list (done)



No Venue Suggested Exception:
	- Catch in VoteStartJob, check for venues.count == 0
	- If venues.count == 0, email owner (no_venue_email) to warn them to add venues (need to add suggest venue button)
	- Owner can add venues throughout voting process
	- Catch in EventFinishJob that venues == 0, email owner (no_venue_email_final).  Archive event as "Finished"
	- 



Merge Venue Suggestion/Voting Phases: Allow people to suggest venues and vote whenever
- Need to keep track of votes --> remove old vote from old venue and add to new venue when vote is changed
	1. Already check if user has voting for venue --> modify to delete old venue-vote associate and create new one
	2. Make sure vote count gets changed dynamically (on vote click)
- Remove all "Pre-Voting" and "Voting" decision points
	1. Event#index countdowns
	2. Event#show countdowns
	3. Action buttons on index
	4. Showing of Suggest venue button
- Change all countdowns to just "Time Left to Vote"
- Change delayed jobs
- change mailers

-RSVP list code for show.html.erb

					<% if @event.stage == "Finished" %>
						<div id = "rsvpList">
							<div id = "rsvpButton-container">
								<%= button_to "RSVP", {:controller => "events", :action => "rsvp_yes", :event_id => @event.id}, {:class => "rsvpButton btn btn-success", :id => "rsvpButton", :remote => true } %>
							</div>
							<ul>
								<p>Attendees:</p>
								<% Rsvp.where(:event_id => @event.id).each_with_index do |rsvp, index| %>
									<%= tag(:li, {id: "rsvpItem" + index.to_s, class: "rsvpItem"}) %><%= rsvp.user.username %>

									<% if rsvp.user == current_user %>
										<%= link_to 'x', {:controller => "events", :action => "rsvp_no", :rsvp_id => rsvp.id, :index => index}, {:id => "rsvp-delete", :remote => true} %></li>
									<% end %>

								</li>
								<% end %>
							</ul>
						</div> <!--rsvpList -->
					<% end %>