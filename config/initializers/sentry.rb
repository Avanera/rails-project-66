# frozen_string_literal: true

Sentry.init do |_config|
  Sentry.init do |config|
    config.dsn = Rails.application.credentials.sentry_dsn
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
    config.enabled_environments = %w[production]
    config.excluded_exceptions += ['ActionController::RoutingError', 'ActiveRecord::RecordNotFound']
    config.traces_sample_rate = 1.0
    config.profiles_sample_rate = 1.0
  end
end
