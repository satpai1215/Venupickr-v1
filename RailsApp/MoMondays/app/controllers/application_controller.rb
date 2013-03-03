class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!, except: [:index, :show]


	def after_sign_in_path_for(resource)
 	end

end
