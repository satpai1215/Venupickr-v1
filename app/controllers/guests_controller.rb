class GuestsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_event, :only => [:new, :destroy, :leave_event, :update_guestlist]
	before_filter :auth_owner, only: [:new, :update]

#before_filter methods
	def get_event
		@event = Event.find(params[:event_id])
	end

	def auth_owner
		if(current_user.id != @event.owner_id)
			redirect_to events_path, :notice => "You are not authorized to do that."
		end
	end
#end before_filter methods

	def omnicontacts
		@event = Event.find_by_id(session[:event_id])

		current_user.get_contacts(request)

		if @event
			redirect_to event_guests_path(@event), notice: "Gmail contacts loaded."
		else #session event_id not stored properly
			redirect_to events_path, notice: "Could not authenticate your gmail account"
		end
	end


	def omnicontacts_failure
		@event  = Event.find_by_id(session[:event_id])
		if @event
			redirect_to event_guests_path(@event), notice: "Could not authenicate our gmail Account"
		else
			redirect_to events_path, notice: "Could not authenicate our gMmil Account"
		end
	end



	def new
		session[:event_id] = @event.id
		#replace true with allow_invite_guests? or equivalent
		if(current_user.id === @event.owner_id or true)
			if (current_user.gmail_contacts) 
				gon.contacts = current_user.gmail_contacts
			end
		    respond_to do |format|
	        	format.html
	        	format.js
		    end
		else
			redirect_to events_path, :notice => "You are not authorized to do that."
		end
	end

	def update_guestlist

		#pseudo-code
		# Step 1: Step through params[:recipients]
		# Step 2: If recipient is a user (i.e. User.find_by_email), invite, add email to invite_array, send invite email
		# Step 3: If recipient is not a user, send app invite to user (include invitation_token in url)
		# Step 4: When new user clicks on sign_up link in invite, check for invitation_token.
				#a: if invitation_token exists, link user to corresponding event after signup
				#b: else sign up user as normal, no link to event

		#AutoMailer.send_invite_email(@event.id, params[:recipients]).deliver

		respond_to do |format|
			format.html {redirect_to @event, notice: "An invitation has been emailed to your guests."}
			#format.js
		end

	end

	def leave_event
		#don't allow event_owner to leave their own event (they should delete the event)
		if(current_user.id != @event.owner_id)
			@event.uninvite!(current_user.id)
			redirect_to events_path, notice: "You successfully left '#{@event.name}.'"
		else
			redirect_to events_path, :notice => "You cannot leave your own event. Please delete the event."
		end
	end


	def destroy

	end


end