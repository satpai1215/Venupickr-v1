class Event < ActiveRecord::Base
  attr_accessible :name, :stage, :event_start, :vote_end, :winner, :event_email_job_id,
                  :voting_email_job_id, :notes, :datepicker, :timepicker, :archive_job_id, :owner_id, :allow_venue_suggestion

  attr_accessor :datepicker, :timepicker

  has_many :venues, dependent: :destroy
  has_many :voters, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :guests
  has_many :guests, dependent: :destroy
  has_many :updates

  validates :name, :datepicker, :timepicker, :presence => true
  validates_format_of :datepicker, with: /^\d{2}[\/-]\d{2}[\/-]\d{4}/
  validates_format_of :timepicker, with: /^\d{1,2}:\d{2}[ap]m/i
  #validate :event_start_valid?, :on => :save

  before_save :build_event_start_and_validate, :on => [:create, :update]
  before_validation :sanitize_user_input


  def to_s
    self.name
  end

  def invite!(user_id)
    association = self.guests.where(:user_id => user_id).first
    if !association
      self.guests.create!(:user_id => user_id)
      AutoMailer.send_invite_email(self.id, user_id).deliver
    end
  end

  def uninvite!(user_id)
    association = self.guests.where(:user_id => user_id).first
    if association
      association.destroy
    end
  end

  def owner
    User.find(self.owner_id)
  end



private
  def build_event_start_and_validate
    begin
      @date = Date.strptime(@datepicker, '%m/%d/%Y')
      @time = Time.parse(@timepicker)
    rescue ArgumentError
      errors.add(:event_start, "date is not a valid date or format (must be a valid date with mm/dd/yyyy hh:mm ampm)" )
      return false
    else
      #converts to datetime in PDT for easier date subtraction
      self.event_start = DateTime.parse("#{@date} #{@time}")
      event_start_valid? unless (self.stage == "Finished" or self.stage == "Archived") #validates event_start
    end
  end

  def event_start_valid?
    @date = (self.event_start - self.vote_end.hours)

    if @date.past?
      errors.add(:vote_end, "happens in the past!" )
      return false
    end
  end

  before_create do 
    self.stage = "Voting"
  end

  def sanitize_user_input
    self.name = ActionController::Base.helpers.sanitize(self.name)
    self.notes = ActionController::Base.helpers.sanitize(self.notes)
  end

end
