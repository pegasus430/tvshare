require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'example@example.com',
      username: 'example', password: 'password')
  end

  test 'user can login with username' do
    params = {
      username: @user.username,
      password: 'password'
    }
    post auth_login_path, params: params, as: :json

    assert :success
    assert json_response.has_key?('token')
    refute json_response.has_key?('error')
  end

  test 'user can login with email' do
    params = {
      username: @user.email,
      password: 'password'
    }
    post auth_login_path, params: params, as: :json

    assert :success
    assert json_response.has_key?('token')
    refute json_response.has_key?('error')
  end

  test 'user cannot login with invalid password' do
    params = {
      username: @user.username,
      password: 'invalid_password'
    }
    post auth_login_path, params: params, as: :json

    refute json_response.has_key?('token')
    assert json_response.has_key?('error')
    assert :unauthorized
  end

end
