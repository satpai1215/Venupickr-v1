class Voter < ActiveRecord::Base
	attr_accessible :event_id, :user_id, :venue_id

 	belongs_to :event
  	belongs_to :user
  	belongs_to :venue
end
