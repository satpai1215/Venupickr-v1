class PagesController < ApplicationController
  
  def welcome
  end

  def info
  end

  def upcoming
  	@events = current_user.events.stage_finished.paginate(:page => params[:page], :per_page => 12)
  end

  def archived
  	@events = current_user.events.stage_archived.paginate(:page => params[:page], :per_page => 12)
  end
end
