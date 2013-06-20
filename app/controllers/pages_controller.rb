class PagesController < ApplicationController
  def info
  end

  def upcoming
  	@events = Event.where(:stage => "Finished").order("event_start DESC").paginate(:page => params[:page], :per_page => 12)
  end

  def archived
  	@events = Event.where(:stage => "Archived").order("event_start DESC").paginate(:page => params[:page], :per_page => 12)
  end
end
