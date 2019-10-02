class ApplicationMailer < ActionMailer::Base
  default from: "mailgun@#{ENV["MAILGUN_DOMAIN"]}"
  layout 'mailer'
end
