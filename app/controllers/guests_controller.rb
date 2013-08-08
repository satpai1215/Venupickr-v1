class GuestsController < ApplicationController
	before_action :authenticate_user!

	def new
	    @guest = Guest.new

	    respond_to do |format|
        	format.html { render :partial => "guest_form" }
        	format.js
	    end
	end

	def create

	end


	def destroy

	end


end