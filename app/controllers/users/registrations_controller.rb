class Users::RegistrationsController < Devise::RegistrationsController
	after_filter only: :create do |c|
		c.link_new_user_to_event(params)
	end

	def new
		session[:invite_token] = params[:invitation_token]
		puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#{params}"
		super
	end

	def update
		if params[:unlink_gmail_contacts]
			current_user.update_attribute(:gmail_contacts, [])
    		current_user.update_attribute(:gmail_contacts_updated_at, nil)
		end
		super
	end

	protected 

	# def after_inactive_sign_up_path_for(resource)
 #    	'/an/example/path'
 #  	end

	#if user signed up via an event invitation, add user as guest to event after signup
	def link_new_user_to_event(params)
		@token = params[:invitation_token]
		if @token
			@event = Event.decrypt(@token)
			@user = User.find_by_email(params[:user][:email])
			if @event
				@event.invite!(@user.id) unless @user.nil?
			end
		end
	end

end