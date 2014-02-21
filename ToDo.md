GROUPS TO DO

- checkbox for guest invites (will not allow guests to invites others yet, because they can also uninvite others)
- update already existing events on heroku to include all guests (migration?)

OTHER TO DO\
- allow for venue editing without vote reset?
- checkbox for guest invites? (disable uninviting of guests by non-owners)

ActiveRecord::Base.connection.reset_pk_sequence!('table_name') #to reset db IDs
include Rails.application.routes.url_helpers






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


					<!--   <div class="field">
    <%#= f.label :event_start, "When is the Event?" %>
    <div id = "datetime_select">
       <%#= f.datetime_select :event_start, {:ampm => true, :use_short_month => true, :default => {:day => Time.now.day, :hour => '20', :minute => '0'}, :start_year => Time.now.year, :minute_step => 1} %>
    </div>
  </div> -->




  #OLD GUEST CONTROLLER CODE:

  		# @current_guest_ids = (@event.users.map { |u| u.id }).sort #cannot be nil since owner is always a guest
		# @new_guest_ids = params[:guest_ids] #checked guests on form


		# if !@new_guest_ids.nil?

		# 	#uninvite users that are not checked unless owner
		# 	@current_guest_ids.each do |id|
		# 		if !@new_guest_ids.find_index(id.to_s) and current_user.id != id
		# 			@event.uninvite!(id)
		# 		end
		# 	end

		# 	#invite users that are checked if they aren't already invited
		# 	guest_emails = Array.new
		# 	@new_guest_ids.each do |id|
		# 		id = id.to_i
		# 		if !@current_guest_ids.find_index(id)
		# 			@event.invite!(id)
		# 			guest_emails.push(User.find(id).email)
		# 		end
		# 	end
		# 	AutoMailer.send_invite_email(@event.id, guest_emails).deliver

		# else #if no guests are checked, remove all guests except owner
		# 	@event.guests.destroy_all
		# 	@event.invite!(current_user.id)
		# end


