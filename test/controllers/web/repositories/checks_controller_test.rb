# frozen_string_literal: true

require 'test_helper'

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      def setup
        sign_in(users(:one))
        @repository = repositories(:javascript)
      end

      test 'should get show' do
        get repository_check_url(@repository.id, repository_checks(:one).id)

        assert { response.successful? }
      end

      test 'should create check' do
        def Dir.exist?(*_args)
          true
        end

        assert_difference('Repository::Check.count', 1) do
          post repository_checks_url(@repository)
        end
        assert { response.redirect? && response.location == repository_url(@repository) }
        assert { flash[:notice] == I18n.t('web.repositories.checks.create.success') }
        check = @repository.checks.last
        assert { check.passed }
      end
    end
  end
end
