# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      @user = User.find_or_create_by(email: auth.info['email'])
      update_user_data

      session[:user_id] = @user.id if @user.persisted?
      redirect_to root_path
    end

    def logout
      session[:user_id] = nil
      redirect_to root_path
    end

    private

    def update_user_data
      @user.update!(
        nickname: auth.info['nickname'],
        name: auth.info['name'],
        image_url: auth.info['image'],
        token: auth.credentials['token']
      )
    end

    def auth
      request.env['omniauth.auth']
    end
  end
end
