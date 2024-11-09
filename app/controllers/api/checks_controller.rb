# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  WEBHOOK_GITHUB_EVENT = 'push'

  def create
    return head :unauthorized unless valid_signature?
    return head :unprocessable_entity unless valid_github_event?

    repository = find_repository
    return head :not_found unless repository

    check = repository.checks.create
    process_check_job(repository, check)
  end

  private

  def valid_signature?
    return true unless request.env['HTTP_X_HUB_SIGNATURE_256']

    secret = Rails.application.credentials.webhook_secret_github
    digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, request.raw_post)
    signature = "sha256=#{digest}"
    Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE_256'])
  end

  def valid_github_event?
    github_event_header = request.headers['X-GitHub-Event']
    return true unless github_event_header

    github_event_header == WEBHOOK_GITHUB_EVENT
  end

  def find_repository
    Repository.find_by(github_id: params.dig(:repository, :id))
  end

  def process_check_job(repository, check)
    if CheckRepositoryJob.perform_later(repository, check)
      head :ok
    else
      head :internal_server_error
    end
  end
end
