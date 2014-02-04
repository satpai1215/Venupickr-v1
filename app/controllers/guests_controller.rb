class GuestsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_event, :only => [:new, :edit, :destroy, :leave_event]
	#before_filter :auth_owner, :only => [:edit, :destroy]

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
			redirect_to event_guests_path(@event)
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

		@event = Event.find(params[:event_id])


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