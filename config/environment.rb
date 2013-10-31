# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MoMondays::Application.initialize!

#Mailer settings
 config.action_mailer.smtp_settings = {
  :address              => "smtpout.secureserver.net",
  :port                 => 80,
  :domain               => 'mo-mondays.com',
  :user_name            => 'info@mo-mondays.com',
  :password             => 'moproblems',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }


