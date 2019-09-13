# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
   address:              'escm.port0.org',
   port:                 587,
   domain:               'escm.port0.org',
   user_name:            '<username>',
   password:             '<password>',
   authentication:       'plain',
   enable_starttls_auto: true
}
ActionMailer::Base.default_content_type = "text/html"
