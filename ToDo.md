GROUPS TO DO
-allow guest selection during event creation
-allow guest selection on event#show
-show guests on event#show
-allow event guests to invite other guests?

OTHER TO DO
- have a checkbox to determine if people other than event_owner can suggest venues (optional)





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

  ActiveRecord::Base.connection.reset_pk_sequence!('table_name') #to reset db IDs


