class AutoMailer < ActionMailer::Base
  default from: "MoMondaysMailer@gmail.com"

  def event_create_email(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => "pai.satyan@gmail.com", :subject => "#{@event.user} Has Created '#{@event.name}' on MoMondays")
  end

  def event_email(event_id)
  	@event = Event.find(event_id)
    @winner = Venue.find(@event.winner)
  	@url = event_url(@event)
  	mail(:to => "pai.satyan@gmail.com", :subject => "Your Event Has Finished")
  end
  #handle_asynchronously :event_email

  def vote_email(event_id)
  	@event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => "pai.satyan@gmail.com", :subject => "Voting for '#{@event.name}' Has Started")
  end

  def no_venue_email(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => "pai.satyan@gmail.com", :subject => "No Venues Suggested for '#{@event.name}'")
  end

  def no_venue_email_final(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => "pai.satyan@gmail.com", :subject => "Your Event '#{@event.name}' Has Been Removed (No Venues Suggested)")
  end


end
