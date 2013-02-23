class User < ActiveRecord::Base
  attr_accessible :email, :password, :username
  has_many :events. :venues

  validates :username, :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
