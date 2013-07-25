class PagesController < ApplicationController
  def info
  end

  def upcoming
  	@events = current_user.events.where(:stage => "Finished").order("event_start ASC").paginate(:page => params[:page], :per_page => 12)
  end

  def archived
  	@events = current_user.events.where(:stage => "Archived").order("event_start DESC").paginate(:page => params[:page], :per_page => 12)
  end
end
