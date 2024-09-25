# frozen_string_literal: true

class AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    post auth_request_path('github')

    assert_response :redirect
  end

  test 'callback should create user' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: 'john@example.com',
        name: 'john',
        nickname: 'john',
        image_url: 'example.com'
      },
      credentials: {
        token: 'ghp_23iac7xzd0t95p496ir4h5j11r73qomtpkzv'
      }
    }
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')

    assert_response :redirect
    user = User.find_by(email: auth_hash[:info][:email].downcase)
    assert_equal(user, current_user)
    assert signed_in?
  end

  test 'logout should delete session' do
    sign_in users(:one)
    assert session[:user_id]

    delete logout_url

    assert_not session[:user_id]
  end
end
