class AutoMailer < ActionMailer::Base
  default from: "from@example.com"


  def event_email(event)
  	@event = event
  	@url = event_url(@event, :host => "0.0.0.0:3000") %>
  	mail(:to => "pai.satyan@gmail.com", :subject => "Your Event Has Finished")
  end

end
