class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:archived, :upcoming]


  def info
  end

  def upcoming
  	@events = current_user.events.stage_finished.paginate(:page => params[:page], :per_page => 12)
  end

  def archived
  	@events = current_user.events.stage_archived.paginate(:page => params[:page], :per_page => 12)
  end

  def routing_error
    redirect_to root_path, notice: "That page does not exist."
  end
end
