class AutoMailer < ActionMailer::Base

  default from: "Venupickr <notifications@venupickr.com>", to: "notifications@venupickr.com"
  default css: 'email'

  def find_event_info(event_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @url = event_url(@event)
  end
  

  def event_create_email(event_id)
    find_event_info(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:to => email_list(event_id), :subject => "#{@owner} Has Created '#{@event.name}' on the #{Venupickr::Application::APP_NAME} App!")
  end

  def event_update_email(event_id)
    find_event_info(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:to => email_list(event_id), :subject => "#{@owner} Has Updated '#{@event.name}' on the #{Venupickr::Application::APP_NAME} App!")
  end

  def send_invite_email(event_id, guest_emails)
    find_event_info(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:to => guest_emails, :subject => "You have been invited to an event on the #{Venupickr::Application::APP_NAME} App!")
  end

  def send_new_user_invite_email(event_id, new_guest_emails)
    find_event_info(event_id)
    @token = Event.encrypt(@event.id)
    @new_user_url = new_user_registration_with_token_url(@token)
    @existing_user_url = new_user_session_with_token_url(@token)
    mail(:to => new_guest_emails, :subject => "You have been invited to join the #{Venupickr::Application::APP_NAME} App!")
  end


  def venue_suggested_email_owner(event_id, user_id)
    find_event_info(event_id)
    @venue_owner = User.find(user_id)
    mail(:to => @owner.email, :subject => "ALERT: A venue has been suggested for your event, '#{@event.name}'")
  end

  def venue_suggested_email_guest(event_id, user_id)
    find_event_info(event_id)
    @venue_owner = User.find(user_id)
    mail(:to => email_list(event_id, true), :subject => "ALERT: A venue has been suggested for the event '#{@event.name}' on the #{Venupickr::Application::APP_NAME} App!")
  end

  def event_finish_email(event_id)
    find_event_info(event_id)
    @winner = Venue.find(@event.winner)
    @winner.address = @winner.address.gsub("<br>", "\n")
    mail(:to => email_list(event_id), :subject => "Voting for '#{@event.name}' Has Finished")

  end

  def voting_reminder_email(event_id)
    find_event_info(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:to => email_list(event_id), :subject => "REMINDER: '#{@event.name}' is on the clock on the #{Venupickr::Application::APP_NAME} App!")
  end

  def finished_reminder_email(event_id)
    find_event_info(event_id)
    @winner = Venue.find(@event.winner)
    @winner.address = @winner.address.gsub("<br>", "\n")
    mail(:to => email_list(event_id), :subject => "REMINDER: '#{@event.name}' has been scheduled on the #{Venupickr::Application::APP_NAME} App!")

  end

  def vote_email(event_id)
    find_event_info(event_id)
    @vote_end = @event.event_start - 8.hours
    mail(:to => email_list(event_id), :subject => "ALERT: Voting for '#{@event.name}' Has Started")
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
