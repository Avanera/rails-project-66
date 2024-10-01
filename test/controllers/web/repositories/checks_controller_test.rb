# frozen_string_literal: true

require 'test_helper'

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      def setup
        sign_in(users(:one))
      end

      test 'should get show' do
        get repository_check_url(repositories(:one).id, repository_checks(:one).id)

        assert { response.successful? }
      end

      test 'should create check' do
        assert_difference('Repository::Check.count') do
          post repository_checks_url(repositories(:one))
        end

        assert { response.redirect? && response.location == repository_url(repositories(:one)) }
        assert { flash[:notice] == I18n.t('web.repositories.checks.create.success') }
        assert_enqueued_jobs 1
      end
    end
  end
end
