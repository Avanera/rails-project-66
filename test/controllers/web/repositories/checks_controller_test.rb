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
        assert_difference('Repository::Check.count', 1) do
          post repository_checks_url(@repository)
        end

        assert { response.redirect? && response.location == repository_url(@repository) }
        assert { flash[:notice] == I18n.t('web.repositories.checks.create.success') }
        new_check = @repository.checks.last

        assert(new_check.passed)

        assert_emails 0
      end
    end
  end
end
