class Event < ActiveRecord::Base
  attr_accessible :name, :user_id, :stage, :event_start, :vote_start
  belongs_to :user
  has_many :venues, dependent: :destroy
  has_many :voters, dependent: :destroy

  validate :vote_start_is_not_past

  def to_s
    self.name
  end

  def vote_start_is_not_past
  	date = (self.event_start.to_datetime - self.vote_start.days)
  	if (date).past?
  		errors.add(:vote_start, " happens in the past, #{date.to_s}" )
  	end
  end


end
