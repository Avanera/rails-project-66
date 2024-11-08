# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'minitest/mock'

OmniAuth.config.test_mode = true

# create an external link for web hooks
Rails.application.routes.default_url_options[:host] = 'example.com'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def load_fixture(filename)
      File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
    end
  end
end

module ActionDispatch
  class IntegrationTest
    setup do
      queue_adapter.perform_enqueued_jobs = true
    end

    def sign_in(user, _options = {}) # rubocop:disable Metrics/MethodLength
      auth_hash = {
        provider: 'github',
        uid: '12345',
        info: {
          email: user&.email || 'john@example.com',
          name: user&.name || 'john',
          nickname: user&.nickname || 'john',
          image_url: user&.image_url || 'example.com'
        },
        credentials: {
          token: user&.token || 'ghp_23iac7xzd0t95p496ir4h5j11r73qomtpkzv'
        }
      }
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
      get callback_auth_url('github')
    end

    def signed_in?
      session[:user_id].present? && current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
