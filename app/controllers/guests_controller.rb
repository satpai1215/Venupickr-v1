class GuestsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_event
	before_filter :auth_owner, :only => [:new, :edit, :destroy]

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
	    respond_to do |format|
        	format.html { render :partial => "guest_form" }
        	#format.js
	    end
	end

	def create

	end


	def destroy

	end


end