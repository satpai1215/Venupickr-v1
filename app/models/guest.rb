class Guest < ActiveRecord::Base
	attr_accessible :user_id, :event_id, :going

	belongs_to :user
  	belongs_to :event
end
