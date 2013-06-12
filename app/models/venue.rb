class Venue < ActiveRecord::Base
  attr_accessible :address, :event_id, :name, :user_id, :votecount, :user, :event, :url, :comments
  belongs_to :user
  belongs_to :event

  has_many :voters, dependent: :destroy
  validates :name, :address, presence: true

  def to_s
    self.name
  end

end
