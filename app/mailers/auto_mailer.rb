class AutoMailer < ActionMailer::Base
  default from: "from@example.com"

  def event_email(event_id)
  	@event = Event.find(event_id)
  	@url = event_url(@event, :host => "0.0.0.0:3000")
  	mail(:to => "pai.satyan@gmail.com", :subject => "Your Event Has Finished")
  end
  #handle_asynchronously :event_email

  def vote_email(event_id)
  	@event = Event.find(event_id)
    @url = event_url(@event, :host => "0.0.0.0:3000")
    mail(:to => "pai.satyan@gmail.com", :subject => "Your Event Has Finished")
  end


end
