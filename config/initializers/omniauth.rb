# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Rails.application.credentials.client_id_github,
           Rails.application.credentials.client_secret_github,
           scope: 'user,public_repo,admin:repo_hook'
end
