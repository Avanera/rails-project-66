# frozen_string_literal: true

require 'sidekiq/web' if Rails.env.development?

Rails.application.routes.draw do
  scope module: :web do
    resources :repositories, only: %i[index show new create] do
      resources :checks, only: %i[create show], module: :repositories
    end

    root 'welcome#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete '/logout', to: 'auth#logout'
  end

  namespace :api do
    resources :checks, only: [:create]
  end

  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end
