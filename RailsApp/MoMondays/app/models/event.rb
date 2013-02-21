class Event < ActiveRecord::Base
  attr_accessible :address, :date, :name, :votecount, :user_id
  belongs_to :user
end
