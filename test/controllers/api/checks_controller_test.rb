# frozen_string_literal: true

require 'test_helper'

module Api
  class ChecksControllerTest < ActionDispatch::IntegrationTest
    include ActiveJob::TestHelper

    def setup
      @repository = repositories(:javascript)
      @test_payload = { repository: { id: @repository.github_id } }.to_json
    end

    test 'should create check, the check of the javascript repo should pass' do
      def Dir.exist?(*_args)
        true
      end
      headers = {
        'X-Hub-Signature-256' => valid_signature,
        'X-GitHub-Event' => 'push',
        'Content-Type' => 'application/json'
      }

      assert_difference('Repository::Check.count', 1) do
        perform_enqueued_jobs do
          post api_checks_url, params: @test_payload, headers:
        end
      end

      check = @repository.checks.last

      assert { check.passed }
      assert { check.finished? }

      assert_response :created
    end

    def valid_signature
      digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'),
                                       ENV.fetch('GITHUB_WEBHOOK_SECRET'), @test_payload)
      "sha256=#{digest}"
    end
  end
end
