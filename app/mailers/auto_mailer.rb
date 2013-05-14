class AutoMailer < ActionMailer::Base
  default from: "MoMondaysMailer@gmail.com"

  def event_create_email(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => email_list, :subject => "#{@event.user} Has Created '#{@event.name}' on MoMondays")
  end

  def event_email(event_id)
  	@event = Event.find(event_id)
    @winner = Venue.find(@event.winner)
  	@url = event_url(@event)
    mail(:to => email_list, :subject => "Your Event Has Finished")

  end

  def vote_email(event_id)
  	@event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => email_list, :subject => "Voting for '#{@event.name}' Has Started")
  end

  def no_venue_email(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => email_list, :subject => "No Venues Suggested for '#{@event.name}'")
  end

  def no_venue_email_final(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => email_list, :subject => "Your Event '#{@event.name}' Has Been Removed (No Venues Suggested)")
  end

  private
  def email_list
    list = Array.new
    User.where(:notification_emails => true).each do |user|
      list.push(user.email)
    end

    return list
  end

end
