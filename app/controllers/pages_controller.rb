class PagesController < ApplicationController
  def info
  end

  def history
  	@events = Event.where(:stage => "Finished").order("created_at DESC").paginate(:page => params[:page], :per_page => 12)
  end
end
