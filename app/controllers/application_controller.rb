# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

  def default_url_options
    { lang: I18n.locale }
  end

  private

  def switch_locale(&)
    locale = params[:lang] || I18n.default_locale
    I18n.with_locale(locale, &)
  end
end
