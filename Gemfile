# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.4'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password
# [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants
# [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# rubocop:disable Bundler/OrderedGems
# Sentry's Ruby SDK allows users to report messages, exceptions, and tracing events.
gem 'stackprof'
gem 'sentry-ruby'
gem 'sentry-rails'
# rubocop:enable Bundler/OrderedGems

# State machines for Ruby classes
gem 'aasm'
# Bootstrap framework styles and components
gem 'bootstrap', '~> 5.3.3'
# Extends dotenv to enforce required environment variables from .env before deployment.
gem 'dotenv-rails'
# A simple, configurable object container implemented in Ruby
gem 'dry-container'
# Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper/Sequel support
gem 'enumerize'
# Octokit.rb wraps the GitHub API in a flat API client that follows Ruby conventions.
gem 'octokit'
# OmniAuth is a library that standardizes multi-provider authentication for web applications.
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
# Minimal authorization through OO design and pure Ruby classes
gem 'pundit'

gem 'rubocop-capybara', require: false
gem 'rubocop-rails', require: false
# Simple, efficient background processing for Ruby
gem 'sidekiq'
# Simple Form is a flexible tool helping you with powerful components to create your forms.
gem 'simple_form'
# Slim is a fast, lightweight templating engine
gem 'slim'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'faker'
  # gem 'i18n-debug'
  gem 'pry'
  gem 'slim_lint', require: false
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '>= 1.4'
  gem 'webmock'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'minitest-power_assert'
  gem 'selenium-webdriver'
end

group :production do
  # Use pg as the database for Active Record
  gem 'pg', '~> 1.1'
end
