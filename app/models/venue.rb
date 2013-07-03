class Venue < ActiveRecord::Base
  attr_accessible :address, :event_id, :name, :user_id, :votecount, :user, :event, :url, :comments
  belongs_to :user
  belongs_to :event

  has_many :voters, dependent: :destroy
  validates :name, :address, presence: true

  before_validation :sanitize_user_input

  def to_s
    self.name
  end

  private

  def sanitize_user_input
  	self.name = ActionController::Base.helpers.sanitize(self.name)
  	self.address = ActionController::Base.helpers.sanitize(self.address)
  	self.comments = ActionController::Base.helpers.sanitize(self.comments)
  end

end
