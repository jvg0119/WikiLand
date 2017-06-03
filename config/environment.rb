# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.

Rails.application.initialize!

if Rails.env.development? || Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :domain => 'blocipedia3-joe.herokuapp.com',
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :authentication => :plain,
    :enable_starttls_auto => true
  }

end
