# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TLMafiaQueue::Application.initialize!

# Configuration for using SendGrid on Heroku
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method = :smtp