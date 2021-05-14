require 'test_helper'

class ReportMailerTest < ActionMailer::TestCase
  setup do
    @report = reports(:one)
    @user = @report.user
  end

  test "report_content" do
    # Create the email and store it for further assertions
    email = ReportMailer.with(report: @report).report_content
    subject = "User #{@user.id} has reported content"

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ["no-reply@gotvchat.com"], email.from
    assert_equal [ReportMailer::INTERNAL_EMAIL], email.to
    assert_equal subject, email.subject
    assert email.body.to_s.include?(@report.reportable_type)
    assert email.body.to_s.include?(@report.url)
  end
end
