class Event < ActiveRecord::Base
  attr_accessible :date, :name, :user_id, :time
  belongs_to :user
  has_many :venues, dependent: :destroy
  has_many :voters, dependent: :destroy

  def to_s
    self.name
  end
end
