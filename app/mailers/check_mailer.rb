# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def check_error_email
    @check = params[:check]
    @repository = params[:repository]
    @user = @repository.user
    mail(to: @user.email, subject: t('.subject', repository_name: @repository.name))
  end

  def check_offenses_email
    @repository = params[:repository]
    @check = params[:check]
    @user = @repository.user
    mail(to: @user.email, subject: t('.subject', repository_name: @repository.name))
  end
end
