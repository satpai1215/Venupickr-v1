class Event < ActiveRecord::Base
  attr_accessible :date, :name, :user_id, :time
  belongs_to :user
  has_many :venues, dependent: :destroy
end
