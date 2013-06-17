class Comment < ActiveRecord::Base
  belongs_to :event

  attr_accessible :content, :username, :event_id
end
