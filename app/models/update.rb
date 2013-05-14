class Update < ActiveRecord::Base
  attr_accessible :content, :event_id, :user_id
  belongs_to :user
  belongs_to :event

  after_create :clean_update_log


  private
  #cleans out Update log after 50 entries
  	def clean_update_log
  		if ::Update.count > 50
	    	batch = ::Update.limit(25).order('created_at ASC')
	    	batch.destroy_all
	    end
  	end

end
