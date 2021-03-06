# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
   address:              'example.com',
   port:                 587,
   domain:               'example.com',
   user_name:            '<username>',
   password:             '<password>',
   authentication:       'plain',
   enable_starttls_auto: true
}
ActionMailer::Base.default_content_type = "text/html"
