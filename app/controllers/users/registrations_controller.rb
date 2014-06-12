class Users::RegistrationsController < Devise::RegistrationsController
	after_filter only: :create do |c|
		c.link_new_user_to_event(params)
	end

	def new
		#need to store token in session in case there are validation errors
		session[:invite_token] = params[:invitation_token]
		#puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#{params}"
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
		puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#{params}"
		if @token
			@email = params[:user][:email]
			@event = Event.decrypt(@token)
			@user = User.find_by_email(@email)
			if @event
				@event.invite!(@user.id) unless @user.nil?

				#update unregistered guests list
				@event.remove_unreg_email(@email)
			end
		end
	end

end