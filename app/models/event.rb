class Event < ActiveRecord::Base
  attr_accessible :name, :user_id, :stage, :event_start, :vote_end, :winner, :event_email_job_id,
                  :voting_email_job_id, :notes, :datepicker, :timepicker

  attr_accessor :datepicker, :timepicker


  belongs_to :user
  has_many :venues, dependent: :destroy
  has_many :voters, dependent: :destroy
  has_many :rsvps, dependent: :destroy

  validates :name, presence: true
  validates :datepicker, presence: true
  validates :timepicker, presence: true
  validate :event_start_valid?, :on => :create


  before_create :set_defaults
  before_save :build_event_start

  def to_s
    self.name
  end

  def set_defaults
    self.user = current_user
    self.stage = "Voting"
  end

  #create 
  before_validation(:on => :create) do |variable|
    
  end


  end


  def event_start_valid?
    date = (self.event_start - self.vote_end.hours)

    if date.past?
      errors.add(:vote_end, "happens in the past!" )
    end
  end



end
