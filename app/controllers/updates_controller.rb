class UpdatesController < ApplicationController

	#cleans out Update log after 50 entries
	def create
	    if Update.count > 20
	    	batch = Update.limit(15).order('created_at asc')
	    	batch.destroy_all
	    end
  	end

end
