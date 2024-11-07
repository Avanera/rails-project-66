# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@check_bulletins.com'
  layout 'mailer'
end
