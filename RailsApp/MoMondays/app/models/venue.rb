class Venue < ActiveRecord::Base
  attr_accessible :address, :event_id, :name, :user_id, :votecount
  belong_to :user, :event
end
