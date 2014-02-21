class Guest < ActiveRecord::Base
	attr_accessible :user_id, :event_id, :isgoing

	belongs_to :user
  	belongs_to :event

  	scope :going, where(isgoing: true)
  	scope :not_going, where(isgoing: false)

end