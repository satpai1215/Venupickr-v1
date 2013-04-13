class PagesController < ApplicationController
  def info
  end

  def history
  	@finished_events = Event.where(:stage => "Finished").order('event_start DESC')
  end
end
