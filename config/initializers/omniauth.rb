# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch('CLIENT_ID_GITHUB', nil), ENV.fetch('CLIENT_SECRET_GITHUB', nil),
           scope: 'user,public_repo,admin:repo_hook'
end
