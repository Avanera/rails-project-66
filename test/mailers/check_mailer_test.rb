# frozen_string_literal: true

require 'test_helper'

class CheckMailerTest < ActionMailer::TestCase
  def setup
    @check = repository_checks(:one)
    @repository = @check.repository
    @user = @repository.user
  end

  test 'check_error_email' do
    email = CheckMailer.with(
      user: @user,
      check: @check,
      repository: @repository
    ).check_error_email

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [@user.email], email.to
    assert_equal I18n.t('check_mailer.check_error_email.subject',
                        repository_name: @repository.name), email.subject

    email_fragment = "К сожалению, проверка (id проверки - #{@check.id}) репозитория \
#{@repository.name} завершилась с ошибкой"
    assert email.text_part.body.raw_source.include?(email_fragment)
  end

  test 'check_offenses_email' do
    email = CheckMailer.with(
      user: @user,
      check: @check,
      repository: @repository
    ).check_offenses_email

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [@user.email], email.to
    assert_equal I18n.t('check_mailer.check_offenses_email.subject',
                        repository_name: @repository.name), email.subject
    email_fragment = "В результате проверки линтером (id проверки - #{@check.id}) репозитория \
#{@repository.name} было обнаружено #{@check.offenses_count} нарушений"
    assert email.text_part.body.raw_source.include?(email_fragment)
  end
end
