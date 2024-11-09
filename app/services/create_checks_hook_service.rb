# frozen_string_literal: true

class CreateChecksHookService
  def run(repository, client)
    client.create_hook(
      repository.full_name,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url,
        content_type: 'json',
        secret: Rails.application.credentials.webhook_secret_github
      },
      { events: ['push'], active: true }
    )
  end
end
