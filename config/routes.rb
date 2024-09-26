# frozen_string_literal: true

Rails.application.routes.draw do
  resources :repositories, only: %i[index show new create]
  root 'welcome#index'

  post 'auth/:provider', to: 'auth#request', as: :auth_request
  get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
  delete '/logout', to: 'auth#logout'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
