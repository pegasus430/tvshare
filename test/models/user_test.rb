require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test '.generate_reset_password_token generates token and expiration' do
    UserMailer.any_instance.expects(:reset_password).once
    assert_nil @user.password_reset_token
    assert_nil @user.password_reset_token_expiration

    @user.generate_reset_password_token

    assert @user.password_reset_token
    assert @user.password_reset_token_expiration
    assert_equal @user.password_reset_token_expiration.to_date, 3.days.from_now.to_date
  end

  test '#reset_password with invalid token returns not found error' do
    UserMailer.any_instance.expects(:reset_password).never

    assert_raises ActiveRecord::RecordNotFound do
      User.reset_password('123', '123', '123')
    end
  end

  test '#reset_password with expired valid token returns not found error' do
    UserMailer.any_instance.expects(:reset_password).once.returns(true)
    @user.generate_reset_password_token
    @user.password_reset_token_expiration = 1.day.ago
    @user.save

    assert_raises ActiveRecord::RecordNotFound do
      User.reset_password(@user.password_reset_token, '123', '123')
    end
  end

  test '#reset_password with mismatched passwords raises error' do
    UserMailer.any_instance.expects(:reset_password).once.returns(true)
    new_password = SecureRandom.alphanumeric
    @user.generate_reset_password_token
    @user.save

    assert_raises ActiveRecord::RecordInvalid do
      User.reset_password(@user.password_reset_token, new_password, '123')
    end
  end

  test '#reset_password with valid token resets password and clears token' do
    UserMailer.any_instance.expects(:reset_password).once.returns(true)
    new_password = SecureRandom.alphanumeric
    @user.generate_reset_password_token
    @user.save

    User.reset_password(@user.password_reset_token, new_password, new_password)

    @user.reload
    refute @user.password_reset_token
    refute @user.password_reset_token_expiration
  end
end
