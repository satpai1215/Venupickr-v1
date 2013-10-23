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

	def new
		#replace true with allow_invite_guests? or equivalent
		if(current_user.id === @event.owner_id or true)
		    respond_to do |format|
	        	format.html { render :partial => "guest_form" }
	        	format.js
		    end
		else
			redirect_to events_path, :notice => "You are not authorized to do that."
		end
	end

	def update_guestlist
		@event = Event.find(params[:event_id])

		@current_guest_ids = (@event.users.map { |u| u.id }).sort #cannot be nil since owner is always a guest
		@new_guest_ids = params[:guest_ids]
		@invite_emails = []

		if !@new_guest_ids.nil?

			#uninvite users that are not checked
			@current_guest_ids.each do |id|
				if !@new_guest_ids.find_index(id.to_s) and current_user.id != id
					@event.uninvite!(id)
				end
			end

			#invite users that are checked if they aren't already invited
			@new_guest_ids.each do |id|
				id = id.to_i
				if !@current_guest_ids.find_index(id)
					@event.invite!(id)
					AutoMailer.send_invite_email(@event.id, id).deliver
				end
			end

		else #if no guests are checked, remove all guests except owner
			@event.guests.destroy_all
			@event.invite!(current_user.id)
		end

		respond_to do |format|
			format.html {redirect_to @event}
			format.js
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