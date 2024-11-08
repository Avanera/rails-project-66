# frozen_string_literal: true

class CreateChecksHookService
  def run(repository, client)
    client.create_hook(
      repository.full_name,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url(host: ENV.fetch('BASE_URL', nil)),
        content_type: 'json',
        secret: ENV.fetch('GITHUB_WEBHOOK_SECRET')
      },
      { events: ['push'], active: true }
    )
  end
end
