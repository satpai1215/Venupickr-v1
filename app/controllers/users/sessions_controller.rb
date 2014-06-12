class Users::SessionsController < Devise::SessionsController
	after_filter only: :create do |c|
		c.link_new_user_to_event(params)
	end

	def new
		#need to store token in session in case there are validation errors
		session[:invite_token] = params[:invitation_token]
		#puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#{params}"
		super
	end

	def destroy
		reset_session
		super
	end


	protected 

	# def after_inactive_sign_up_path_for(resource)
 #    	'/an/example/path'
 #  	end

	#if user signed in via an event invitation, add user as guest to event after sign in
	def link_new_user_to_event(params)
		@token = params[:invitation_token]
		puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#{params}"
		if @token
			@event = Event.decrypt(@token)
			@user = User.find_by_email(params[:user][:email])
			if @event
				@event.invite!(@user.id) unless @user.nil?
			end
		end
	end


end