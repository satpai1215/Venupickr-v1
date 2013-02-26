class Venue < ActiveRecord::Base
  attr_accessible :address, :event_id, :name, :user_id, :votecount
  belongs_to :user
  belongs_to :event
end
