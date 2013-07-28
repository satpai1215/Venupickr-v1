class AutoMailer < ActionMailer::Base
  default from: "info@mo-mondays.com", to: "info@mo-mondays.com"


  def event_create_email(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => email_list, :subject => "#{@event.user} Has Created '#{@event.name}' on the MoMondaysApp!")
  end

  def venue_suggested_email(event_id, venue_id)
    @event = Event.find(event_id)
    @venue_owner = Venue.find(venue_id).user.username
    @url = event_url(@event)
    mail(:bcc => @event.user.email, :subject => "ALERT: A venue has been suggested for your event, '#{@event.name}'")
  end

  def event_finish_email(event_id)
  	@event = Event.find(event_id)
    @winner = Venue.find(@event.winner)
    @winner.address = @winner.address.gsub("<br>", "\n")
  	@url = event_url(@event)
    mail(:bcc => email_list, :subject => "Voting for '#{@event.name}' Has Finished")

  end

  def voting_reminder_email(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => email_list, :subject => "REMINDER: '#{@event.name}' is on the clock on the MoMondaysApp!")
  end

  def finished_reminder_email(event_id)
    @event = Event.find(event_id)
    @winner = Venue.find(@event.winner)
    @winner.address = @winner.address.gsub("<br>", "\n")
    @url = event_url(@event)
    mail(:bcc => email_list, :subject => "REMINDER: '#{@event.name}' has been scheduled on the MoMondaysApp!")

  end

  def vote_email(event_id)
  	@event = Event.find(event_id)
    @url = event_url(@event)
    @vote_end = @event.event_start - 8.hours
    mail(:bcc => email_list, :subject => "ALERT: Voting for '#{@event.name}' Has Started")
  end

  def no_venue_email(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => @event.user.email, :subject => "WARNING: No Venues Suggested for '#{@event.name}'")
  end

  def no_venue_email_final(event_id)
    @event = Event.find(event_id)
    @url = event_url(@event)
    mail(:to => @event.user.email, :subject => "Your Event '#{@event.name}' Has Been Removed (No Venues Suggested)")
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
