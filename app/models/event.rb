class Event < ActiveRecord::Base
  attr_accessible :name, :user_id, :stage, :event_start, :vote_start, :winner, :event_email_job_id,
                  :voting_email_job_id
  belongs_to :user
  has_many :venues, dependent: :destroy
  has_many :voters, dependent: :destroy

  validates :name, presence: true
  #validate :vote_start_is_not_past, :on => :create

  def to_s
    self.name
  end

  def vote_start_is_not_past
  	date = (self.event_start - self.vote_start.days)

  	if date.past?
  		errors.add(:vote_start, "happens in the past" )
  	end
  end
end
