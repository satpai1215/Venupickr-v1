class PagesController < ApplicationController
  def info
  end

  def history
  	@events = Event.where(:stage => "Finished").order("event_start DESC").paginate(:page => params[:page], :per_page => 12)
  end
end
