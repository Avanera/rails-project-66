# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :user_signed_in?

  private

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
