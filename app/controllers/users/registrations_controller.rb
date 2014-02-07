class Users::RegistrationsController < Devise::RegistrationsController
	after_filter only: :create do |c|
		c.link_new_user_to_event(params[:invitation_token])
	end

	def update
		if params[:unlink_gmail_contacts]
			current_user.update_attribute(:gmail_contacts, [])
    		current_user.update_attribute(:gmail_contacts_updated_at, nil)
		end
		super
	end


	#if user signed up via an event invitation, add user as guest to event after signup
	def link_new_user_to_event(token)
		puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #{token} !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

		if token
			puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! YES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			@event = Event.find_by_invitation_token
			@event.invite!(current_user.id) unless @event.nil?
		end
	end

end