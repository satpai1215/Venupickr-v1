class Event < ActiveRecord::Base
  attr_accessible :name, :user_id, :stage, :event_start, :vote_end, :winner, :event_email_job_id,
                  :voting_email_job_id, :notes
  belongs_to :user
  has_many :venues, dependent: :destroy
  has_many :voters, dependent: :destroy
  has_many :rsvps, dependent: :destroy

  validates :name, presence: true
  #validate :event_start_valid?, :on => :create

  def to_s
    self.name
  end

  def event_start_valid?
  	date = (self.event_start - self.vote_end.hours)

  	if date.past?
  		errors.add(:vote_end, "happens in the past!" )
  	end
  end
end
