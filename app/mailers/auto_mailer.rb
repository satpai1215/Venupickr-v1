class AutoMailer < ActionMailer::Base

  default from: "info@mo-mondays.com", to: "info@mo-mondays.com"


  def find_event_info(event_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @url = event_url(@event)
  end
  
  def mm_update_102213_email
    emails = Array.new
    User.all.each do |u|
      emails.push(u.email)
    end
    mail(:bcc => emails, :subject => "The MoMondaysApp Has Been Updated!")
  end

  def event_create_email(event_id)
    find_event_info(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => email_list(event_id), :subject => "#{@owner} Has Created '#{@event.name}' on the MoMondaysApp!")
  end

  def event_update_email(event_id)
    find_event_info(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => email_list(event_id), :subject => "#{@owner} Has Updated '#{@event.name}' on the MoMondaysApp!")
  end

  def send_invite_email(event_id, guest_emails)
    find_event_info(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => guest_emails, :subject => "You have been invited to an event on the Mo' Mondays App!")
  end

  def venue_suggested_email_owner(event_id, user_id)
    find_event_info(event_id)
    @venue_owner = User.find(user_id)
    mail(:bcc => @owner.email, :subject => "ALERT: A venue has been suggested for your event, '#{@event.name}'")
  end

  def venue_suggested_email_guest(event_id, user_id)
    find_event_info(event_id)
    @venue_owner = User.find(user_id)
    mail(:bcc => email_list(event_id, true), :subject => "ALERT: A venue has been suggested for the event '#{@event.name}' on the MoMondays App!")
  end

  def event_finish_email(event_id)
    find_event_info(event_id)
    @winner = Venue.find(@event.winner)
    @winner.address = @winner.address.gsub("<br>", "\n")
    mail(:bcc => email_list(event_id), :subject => "Voting for '#{@event.name}' Has Finished")

  end

  def voting_reminder_email(event_id)
    find_event_info(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => email_list(event_id), :subject => "REMINDER: '#{@event.name}' is on the clock on the MoMondaysApp!")
  end

  def finished_reminder_email(event_id)
    find_event_info(event_id)
    @winner = Venue.find(@event.winner)
    @winner.address = @winner.address.gsub("<br>", "\n")
    mail(:bcc => email_list(event_id), :subject => "REMINDER: '#{@event.name}' has been scheduled on the MoMondaysApp!")

  end

  def vote_email(event_id)
    find_event_info(event_id)
    @vote_end = @event.event_start - 8.hours
    mail(:bcc => email_list(event_id), :subject => "ALERT: Voting for '#{@event.name}' Has Started")
  end

  def no_venue_email(event_id)
    find_event_info(event_id)
    mail(:to => @owner.email, :subject => "WARNING: No Venues Suggested for '#{@event.name}'")
  end

  def no_venue_email_final(event_id)
    find_event_info(event_id)
    mail(:to => @owner.email, :subject => "Your Event '#{@event.name}' Has Been Removed (No Venues Suggested)")
  end

  private

  #generates array of user emails for passed event
  def email_list(event_id, exclude_owner = false)
    list = Array.new
    @event = Event.includes(:users).find(event_id)

    @event.users.where(:notification_emails => true).each do |user|
      list.push(user.email)
    end

    if(exclude_owner)
      list.delete(@event.owner.email)
    end

    return list
  end

end
