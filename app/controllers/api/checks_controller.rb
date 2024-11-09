# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def create
    return head :unauthorized unless verify_signature_if_any
    return head :unprocessable_entity unless valid_github_event?

    repository = Repository.find_by(github_id: params.dig(:repository, :id))
    return head :not_found unless repository

    check = repository.checks.create
    if CheckRepositoryJob.perform_later(repository, check)
      head :created
    else
      head :internal_server_error
    end
  end

  private

  def verify_signature_if_any
    return true unless request.env['HTTP_X_HUB_SIGNATURE_256']

    secret = ENV.fetch('WEBHOOK_SECRET_GITHUB')
    digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, request.raw_post)
    signature = "sha256=#{digest}"
    Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE_256'])
  end

  def valid_github_event?
    request.headers['X-GitHub-Event'] == 'push'
  end
end
