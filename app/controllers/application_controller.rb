class ApplicationController < ActionController::Base
  protect_from_forgery

after_filter :store_location
before_filter :set_user_time_zone

def store_location
  # store last url as long as it isn't a /users path
  session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
end

def after_sign_in_path_for(resource)
  events_path || root_path
end

def after_update_path_for(resource)
  session[:previous_url] || root_path
end

def set_user_time_zone
	Time.zone = Time.zone.name
end


end
