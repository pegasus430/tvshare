require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:one)
    @user.generate_reset_password_token
  end

  test "reset_password" do
    # Create the email and store it for further assertions
    email = UserMailer.with(user: @user).reset_password
    url  = "https://gotvchat.com/reset_password/#{@user.password_reset_token}"

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ["no-reply@gotvchat.com"], email.from
    assert_equal [@user.email], email.to
    assert_equal "TV Chat password reset instructions", email.subject
    assert email.text_part.body.to_s.include?(url)
    assert email.html_part.body.to_s.include?(url)
  end
end
