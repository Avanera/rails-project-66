# frozen_string_literal: true

module Web
  class ApplicationController < ActionController::Base
    include Pundit::Authorization

    helper_method :current_user, :user_signed_in?

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore
      alert = t "#{policy_name}.#{exception.query}", scope: :pundit, default: :default
      redirect_back(fallback_location: root_path, alert:)
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
    end

    def user_signed_in?
      session[:user_id].present? && current_user.present?
    end

    def authenticate_user!
      return if user_signed_in?

      flash[:alert] = t('flashes.not_logged_in')
      redirect_to root_path
    end
  end
end
