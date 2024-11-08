# frozen_string_literal: true

require 'test_helper'

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:two)
        sign_in(@user)
        @repository = repositories(:ruby)
        @check = repository_checks(:two)
      end

      test 'should get show' do
        get repository_check_url(@repository.id, repository_checks(:two).id)

        assert { response.successful? }
      end

      test 'should create check, sends email when offenses' do
        def Dir.exist?(*_args)
          true
        end

        assert_difference('Repository::Check.count', 1) do
          post repository_checks_url(@repository)
        end

        assert { response.redirect? && response.location == repository_url(@repository) }
        assert { flash[:notice] == I18n.t('web.repositories.checks.create.success') }
        new_check = @repository.checks.last
        assert_not(new_check.passed)

        assert_emails 1
        email = ActionMailer::Base.deliveries.last
        assert_equal [@user.email], email.to
        assert_equal I18n.t('check_mailer.check_offenses_email.subject',
                            repository_name: @repository.name), email.subject
        assert_includes email.html_part.body.to_s, new_check.id.to_s
        assert_includes email.html_part.body.to_s, @repository.name
      end
    end
  end
end
