class Users::RegistrationsController < Devise::RegistrationsController

	def new
		super
	end

	def create
		super
	end

	def update
		if params[:unlink_gmail_contacts]
			current_user.update_attribute(:gmail_contacts, [])
    		current_user.update_attribute(:gmail_contacts_updated_at, nil)
		end
		super
	end

end