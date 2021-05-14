require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should generate reset password flow with valid params" do
    User.any_instance.expects(:generate_reset_password_token).once.returns(true)

    params = { email: @user.email }
    post generate_password_reset_url, params: params
    assert_response :success
  end

  test "should return not found when generate reset password flow email is not found" do
    User.any_instance.expects(:generate_reset_password_token).never

    params = { email: 123 }
    post generate_password_reset_url, params: params
    assert_response :not_found
  end

  test "when account does not exits returns not found" do
    get exists_password_reset_url(email: 123)
    assert_response :not_found
  end

  test "when account exists returns success" do
    get exists_password_reset_url(email: @user.email)
    assert_response :success
  end

  test "saves new password with valid tokens returns success" do
    UserMailer.any_instance.expects(:reset_password).once.returns(true)
    new_password = SecureRandom.alphanumeric
    @user.generate_reset_password_token

    User.expects(:reset_password).with(@user.password_reset_token, new_password, new_password).returns(true)

    post save_password_reset_url, params: {
      token: @user.password_reset_token,
      password: new_password,
      password_confirmation: new_password
    }

    assert_response :success
  end

  test "saves new password with invalid tokens returns failure" do
    User.expects(:reset_password).with('123', '123', '123').raises(ActiveRecord::RecordNotFound)

    post save_password_reset_url, params: {
      token: 123,
      password: 123,
      password_confirmation: 123
    }

    assert_response :not_found
  end
end
